require "byebug"
require "json" # todo: remove

module Cody
  class Logs
    include AwsServices

    def initialize(options, build_id)
      @options, @build_id = options, build_id
      @wait = @options[:wait] || true

      @output = [] # for specs
      @shown_phases = []
      set_trap
    end

    def tail
      complete = false
      until complete do
        resp = codebuild.batch_get_builds(ids: [@build_id])
        build = resp.builds.first
        print_phases(build)
        set_log_group_name(build)

        sleep 5 if @wait && !@@end_loop_signal && !ENV["CODY_TEST"]
        complete = build.build_complete
        start_cloudwatch_tail unless ENV["CODY_TEST"]
      end
      AwsLogs::Tail.stop_follow!
    end

    def start_cloudwatch_tail
      return if @cloudwatch_tail_started
      return unless @log_group_name && @log_stream_name

      Thread.new do
        cloudwatch_tail
      end
      @cloudwatch_tail_started = true
    end

    def cloudwatch_tail
      cw_tail = AwsLogs::Tail.new(
        log_group_name: @log_group_name,
        log_stream_names: [@log_stream_name],
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
        "Status: ".color(:purple), status,
        # "Time: ".color(:purple), details[:start_time],
        "Duration: ".color(:purple), details[:duration_in_seconds],
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
  end
end
