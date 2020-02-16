module Cody
  class Stop < Base
    def run
      run_with_exception_handling do
        codebuild.stop_build(id: build_id)
        puts "Build has been stopped: #{build_id}"
      end
    end
  end
end
