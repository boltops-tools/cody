class Cody::CLI
  class Stop < Base
    def run
      check_build_id!
      run_with_exception_handling do
        codebuild.stop_build(id: build_id)
        puts "Build has been stopped: #{build_id}"
      end
    end
  end
end
