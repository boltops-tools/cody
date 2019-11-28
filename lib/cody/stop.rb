module Cody
  class Stop < Base
    def run
      run_with_exception_handling do
        codebuild.stop_build(id: build_id)
        puts "Build has been stopped: #{build_id}"
      end
    end

    def build_id
      return @options[:build_id] if @options[:build_id]

      resp = codebuild.list_builds_for_project(project_name: @full_project_name)
      resp.ids.first # most recent build_id
    end
  end
end
