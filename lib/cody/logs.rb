module Cody
  class Logs
    include AwsServices

    def initialize(build_id)
      @build_id = build_id
      puts "@build_id #{@build_id}"
    end

    def tail
      complete = false
      until complete do
        resp = codebuild.batch_get_builds(ids: [@build_id])
        build = resp.builds.first
        # pp build
        puts "build.build_complete #{build.build_complete}"
        puts "Time.now: #{Time.now}".color(:green)

        print_log_info(build)

        print_phases(build)

        sleep 5
        complete = build.build_complete
      end
    end

    def print_log_info(build)
      logs = build.logs
      puts "logs.group_name: #{logs.group_name}"
      puts "logs.stream_name: #{logs.stream_name}"
      puts "logs.cloud_watch_logs_arn: #{logs.cloud_watch_logs_arn}"
    end

    require "byebug"
    def print_phases(build)
      puts "phase_type phase_status start_time end_time duration"
      # byebug
      build.phases.each do |phase|
        puts [phase.phase_type, phase.phase_status, phase.start_time, phase.end_time, phase.duration_in_seconds].join(" ")
      end
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
