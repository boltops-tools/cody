# Base only for Stop and Start currently.
class Cody::CLI
  class Base
    extend Memoist
    include Cody::AwsServices
    include Cody::Names::Conventions
    include Cody::Utils::Logging
    include Cody::Utils::Pretty
    include Cody::Utils::Sure

    def initialize(options)
      @options = options
      @project_name = options[:project_name] || inferred_project_name
      @full_project_name = project_name_convention(@project_name)
      @stack_name = normalize_stack_name(options[:stack_name] || inferred_stack_name(@project_name))
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
      find_build
    end

    def find_build
      resp = codebuild.list_builds_for_project(project_name: @full_project_name)
      resp.ids.first # most recent build_id
    rescue Aws::CodeBuild::Errors::ResourceNotFoundException => e
      logger.error "ERROR: #{e.class} #{e.message}".color(:red)
      exit 1
    end

    def check_build_id!
      return if build_id
      puts "WARN: No builds found for #{@project_name.color(:green)} project"
      exit
    end
  end
end
