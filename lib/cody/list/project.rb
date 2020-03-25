# Wrap project in object to allow lazy loading of status
class Cody::List
  class Project
    include Cody::AwsServices
    extend Memoist

    delegate :build_status, :start_time, :end_time, to: :build

    attr_reader :name
    def initialize(name)
      @name = name # Simple string
    end

    def build
      return NoBuildsProject.new unless build_id # most recent build
      resp = codebuild.batch_get_builds(ids: [build_id])
      resp.builds.first
    end
    memoize :build
    alias_method :load, :build # interface to eager load

    def build_id
      resp = codebuild.list_builds_for_project(project_name: @name)
      resp.ids.first # most recent build_id
    end
    memoize :build_id
  end
end
