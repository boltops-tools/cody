require 'cli-format'

module Cody
  class List
    include AwsServices
    extend Memoist

    def initialize(options)
      @options = options
    end

    def run
      presenter = CliFormat::Presenter.new(@options)
      presenter.header = ["Name", "Status"]
      projects.each do |project|
        presenter.rows << [project.name, project.status]
      end
      presenter.show
    end

    def projects
      list_projects.map { |p| Project.new(p) }
    end

    def list_projects
      projects = []
      next_token = :start
      while next_token
        options = {sort_by: "NAME"}
        if next_token && next_token != :start
          options[:next_token] = next_token
        end
        resp = codebuild.list_projects(options)
        next_token = resp.next_token
        projects += resp.projects
      end
      projects
    end
    memoize :list_projects
  end
end
