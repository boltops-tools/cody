module Cody
  class List
    include AwsServices
    extend Memoist

    def initialize(options)
      @options = options
    end

    def run
      projects.each do |project|
        puts project
      end
    end

    def projects
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
    memoize :projects
  end
end
