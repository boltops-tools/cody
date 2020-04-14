require 'cli-format'

module Cody
  class List
    include AwsServices
    extend Memoist

    def initialize(options)
      @options = options
      @sort_by = @options[:sort_by] ? @options[:sort_by].upcase : "NAME" # NAME | CREATED_TIME | LAST_MODIFIED_TIME
    end

    def run
      # TODO: no need for this after cfn-format is also lazy
      # if projects.size > 15
      #   $stderr.puts "Number of projects: #{projects.size}"
      #   $stderr.puts "Can take a while for a large number of projects..."
      # end

      presenter = CliFormat::Presenter.new(@options)
      presenter.header = ["Name", "Status", "Time"]
      projects.each do |project|
        project = Project.new(project)
        row = [project.name, project.build_status, project.end_time]
        presenter.rows << row if show?(project.build_status)
      end
      presenter.show
    end

    def show?(build_status)
      status = @options[:status].upcase if @options[:status]
      if status
        build_status == status
      else
        true
      end
    end

    # Returns flattened lazy Enumerator
    def projects
      list_projects.lazy.flat_map { |p| p }
    end
    memoize :projects

    def list_projects
      Enumerator.new do |y|
        next_token = :start
        while next_token
          options = {sort_by: @sort_by}
          if next_token && next_token != :start
            options[:next_token] = next_token
          end

          resp = codebuild.list_projects(options)
          projects, next_token = resp.projects, resp.next_token

          y.yield(projects, resp)
        end
      end
    end
    memoize :list_projects
  end
end
