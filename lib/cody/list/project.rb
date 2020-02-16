# Wrap project in object to allow lazy loading of status
class Cody::List
  class Project
    include Cody::AwsServices

    attr_reader :name
    def initialize(name)
      @name = name # Simple string
    end

    def status
      resp = codebuild.batch_get_builds(ids: [build_id])
      build = resp.builds.first
      build.build_status
    end

    def build_id
      resp = codebuild.list_builds_for_project(project_name: @name)
      resp.ids.first # most recent build_id
    end
  end
end
