require 'cli-format'

class Cody::CLI
  class List
    include Cody::AwsServices
    extend Memoist

    def initialize(options)
      @options = options
    end

    def run
      if projects.size > 15
        $stderr.puts "Number of projects: #{projects.size}"
        $stderr.puts "Can take a while for a large number of projects..."
      end

      presenter = CliFormat::Presenter.new(@options)
      presenter.header = ["Name", "Status", "Time"]
      projects.each do |project|
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

    def projects
      projects = list_projects.map { |p| Cody::List::Project.new(p) }
      if @options[:sort_by]
        projects.sort_by { |p| p.send(@options[:sort_by]) }
      else
        projects # default name
      end
    end
    memoize :projects

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
      if @options[:select]
        regexp = Regexp.new(@options[:select])
        projects.select! { |p| p =~ regexp }
      end
      projects
    end
    memoize :list_projects
  end
end
