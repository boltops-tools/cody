require "byebug"
require "json" # todo: remove

module Cody
  class Logs
    include AwsServices

    def initialize(options, build_id)
      @options, @build_id = options, build_id
      @wait = @options[:wait] || true
      set_trap
    end

    def tail
      complete = false
      until complete do
        resp = codebuild.batch_get_builds(ids: [@build_id])
        puts "batch_get_builds resp:"
        pp resp

        build = resp.builds.first
        log_info(build)

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

    def log_info(build)
      logs = build.logs
      puts "logs.group_name: #{logs.group_name}"
      puts "logs.stream_name: #{logs.stream_name}"
      puts "logs.cloud_watch_logs_arn: #{logs.cloud_watch_logs_arn}"

      @log_group_name = logs.group_name if logs.group_name
      @log_stream_name = logs.stream_name if logs.stream_name
    end

    def print_phases(build)
      puts "phase_type phase_status start_time end_time duration"
      # byebug
      build.phases.each do |phase|
        puts [phase.phase_type, phase.phase_status, phase.start_time, phase.end_time, phase.duration_in_seconds].join(" ")
      end
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

# buildStatus -> (string)
# The current status of the build. Valid values include:
# FAILED : The build failed.
# FAULT : The build faulted.
# IN_PROGRESS : The build is still in progress.
# STOPPED : The build stopped.
# SUCCEEDED : The build succeeded.
# TIMED_OUT : The build timed out.
