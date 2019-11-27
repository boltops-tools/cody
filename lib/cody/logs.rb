module Cody
  class Logs
    include AwsServices

    def initialize(build_id)
      @build_id = build_id
    end

    def tail
      puts "@build_id #{@build_id}"
      resp = codebuild.batch_get_builds(ids: [@build_id])
      build = resp.builds.first
      puts "build:"
      pp build

      puts "build.build_complete #{build.build_complete}"
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
