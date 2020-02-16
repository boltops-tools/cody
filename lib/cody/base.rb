# Base only for Stop and Start currently.
module Cody
  class Base
    include AwsServices

    def initialize(options)
      @options = options
      @project_name = options[:project_name] || inferred_project_name
      @full_project_name = project_name_convention(@project_name)
    end

    def run_with_exception_handling
      yield
    rescue Aws::CodeBuild::Errors::ResourceNotFoundException => e
      puts "ERROR: #{e.class}: #{e.message}".color(:red)
      puts "CodeBuild project #{@full_project_name} not found."
    rescue Aws::CodeBuild::Errors::InvalidInputException => e
      puts "ERROR: #{e.class}: #{e.message}".color(:red)
    end

    def build_id
      return @options[:build_id] if @options[:build_id]

      resp = codebuild.list_builds_for_project(project_name: @full_project_name)
      resp.ids.first # most recent build_id
    end
  end
end