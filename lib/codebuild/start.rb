module Codebuild
  class Start
    include AwsServices

    def initialize(options)
      @options = options
      @identifier = options[:identifier] || inferred_stack_name # CloudFormation stack or CodeBuild project name
    end

    def run
      resp = codebuild.start_build(
        project_name: project_name,
        source_version: @options[:source_version] || 'master'
      )
      puts "Build started for project: #{project_name}"
    end

    def project_name
      if stack_exists?(@identifier)
        resp = cfn.describe_stack_resources(stack_name: @identifier)
        resource = resp.stack_resources.find do |r|
          r.logical_resource_id == "CodeBuild"
        end
        resource.physical_resource_id # codebuild project name
      elsif project_exists?(@identifier)
        @identifier
      else
        puts "ERROR: Unable to find the codebuild project with identifier #@identifier".color(:red)
        exit 1
      end
    end

  private
    def project_exists?(name)
      resp = codebuild.batch_get_projects(names: [name])
      resp.projects.size > 0
    end
  end
end
