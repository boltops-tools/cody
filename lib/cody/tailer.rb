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

    def find_build
      resp = codebuild.batch_get_builds(ids: [@build_id])
      resp.builds.first
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
        start_cloudwatch_tail unless ENV["CODY_TEST"]
        sleep 5 if !@@end_loop_signal && !complete && !ENV["CODY_TEST"]
      end

      AwsLogs::Tail.stop_follow!
      @thread.join if @thread

      puts "The build took #{build_time(build)} to complete."
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

      status = details[:phase_status]
      status = status&.include?("FAILED") ? status.color(:red) : status
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

    @@end_loop_signal = false
    def set_trap
      Signal.trap("INT") {
        puts "\nCtrl-C detected. Exiting..."
        @@end_loop_signal = true  # useful to control loop
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
