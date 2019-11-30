require "aws-logs"

module Cody
  class Tailer
    include AwsServices

    def initialize(options, build_id)
      @options, @build_id = options, build_id

      @output = [] # for specs
      @shown_phases = []
      @thread = nil
      set_trap
    end

    def run
      puts "Showing logs for build #{@build_id}"

      complete = false
      until complete do
        build = find_build
        unless build
          puts "ERROR: Build id not found: #{@build_id}".color(:red)
          return
        end
        print_phases(build)
        set_log_group_name(build)

        complete = build.build_complete

        next if ENV["CODY_TEST"]
        start_cloudwatch_tail
        sleep 5
      end

      stop_cloudwatch_tail(build)
      final_message(build)
    end

    def final_message(build)
      status = build.build_status.to_s # in case nil
      status = status != "SUCCEEDED" ? status.color(:red) : status.color(:green)
      puts "Final build status: #{status}"
      display_failed_phases(build) if status != "SUCCEEDED"
      puts "The build took #{build_time(build)} to complete."
    end

    def display_failed_phases(build)
      puts "Failed Phases:"
      build.phases.each do |phase|
        next if phase.phase_status == "SUCCEEDED" or phase.phase_status.nil? or phase.phase_status == ""
        puts "#{phase.phase_type}: #{phase.phase_status.color(:red)}"
      end
    end

    def find_build
      resp = codebuild.batch_get_builds(ids: [@build_id])
      resp.builds.first
    end

    def start_cloudwatch_tail
      return if @cloudwatch_tail_started
      return unless @log_group_name && @log_stream_name

      @thread = Thread.new do
        cloudwatch_tail
      end
      @cloudwatch_tail_started = true
    end

    def cloudwatch_tail
      since = @options[:since] || "7d" # by default, search only 7 days in the past
      cw_tail = AwsLogs::Tail.new(
        log_group_name: @log_group_name,
        log_stream_names: [@log_stream_name],
        since: since,
        follow: true,
        format: "simple",
      )
      cw_tail.run
    end

    def stop_cloudwatch_tail(build)
      return if ENV["CODY_TEST"]

      # The AwsLogs::Tail.stop_follow! results in a little waiting because it signals to break the polling loop.
      # Since it's in the middle of the loop process, the loop will finish the sleep 5 first.
      # So it can pause from 0-5 seconds.
      #
      # However, this is sometimes not enough of a pause for CloudWatch to receive and send the logs back to us.
      # So additionally pause on a failed build so we can receive the final logs at the end.
      #
      # provide extra time for cw tail to report error
      sleep 10 if complete_failed?(build) and !logs_command?
      AwsLogs::Tail.stop_follow!
      @thread.join if @thread
    end

    def logs_command?
      ARGV.join(" ").include?("logs")
    end

    # build.build_status : The current status of the build. Valid values include:
    #
    #     FAILED : The build failed.
    #     FAULT : The build faulted.
    #     IN_PROGRESS : The build is still in progress.
    #     STOPPED : The build stopped.
    #     SUCCEEDED : The build succeeded.
    #     TIMED_OUT : The build timed out.
    #
    def complete_failed?(build)
      return if ENV["CODY_TEST"]
      build.build_complete && build.build_status != "SUCCEEDED"
    end

    # Setting enables start_cloudwatch_tail
    def set_log_group_name(build)
      logs = build.logs
      @log_group_name = logs.group_name if logs.group_name
      @log_stream_name = logs.stream_name if logs.stream_name
    end

    def print_phases(build)
      build.phases.each do |phase|
        details = {
          phase_type: phase.phase_type,
          phase_status: phase.phase_status,
          start_time: phase.start_time,
          duration_in_seconds: phase.duration_in_seconds,
        }
        display_phase(details)
        @shown_phases << details
      end
    end

    def display_phase(details)
      already_shown = @shown_phases.detect do |p|
        p[:phase_type] == details[:phase_type] &&
        p[:phase_status] == details[:phase_status] &&
        p[:start_time] == details[:start_time] &&
        p[:duration_in_seconds] == details[:duration_in_seconds]
      end
      return if already_shown

      status = details[:phase_status].to_s # in case of nil
      status = status == "SUCCEEDED" ? status.color(:green) : status.color(:red)
      say [
        "Phase:".color(:green), details[:phase_type],
        "Status:".color(:purple), status,
        # "Time: ".color(:purple), details[:start_time],
        "Duration:".color(:purple), details[:duration_in_seconds],
      ].join(" ")
    end

    def say(text)
      ENV["CODY_TEST"] ? @output << text : puts(text)
    end

    def output
      @output.join("\n") + "\n"
    end

    def set_trap
      Signal.trap("INT") {
        puts "\nCtrl-C detected. Exiting..."
        exit # immediate exit
      }
    end

    def build_time(build)
      duration = build.phases.inject(0) { |sum,p| sum + p.duration_in_seconds.to_i }
      pretty_time(duration)
    end

    # http://stackoverflow.com/questions/4175733/convert-duration-to-hoursminutesseconds-or-similar-in-rails-3-or-ruby
    def pretty_time(total_seconds)
      minutes = (total_seconds / 60) % 60
      seconds = total_seconds % 60
      if total_seconds < 60
        "#{seconds.to_i}s"
      else
        "#{minutes.to_i}m #{seconds.to_i}s"
      end
    end
  end
end
