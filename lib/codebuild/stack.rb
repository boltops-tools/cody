require "aws-sdk-cloudformation"

module Codebuild
  class Stack
    include AwsServices

    def initialize(options)
      @options = options
      @project_name = @options[:project_name] || inferred_project_name
      @stack_name = options[:stack_name] || inferred_stack_name(@project_name)

      @full_project_name = project_name_convention(@project_name)
      @template = {
        "Description" => "CodeBuild Project: #{@full_project_name}",
        "Resources" => {}
      }
    end

    def run
      options = @options.merge(
        project_name: @project_name,
        full_project_name: @full_project_name,
      )
      project_builder = Project.new(options)
      unless project_builder.exist?
        puts "ERROR: Codebuild project does not exist: #{project_builder.project_path}".color(:red)
        exit 1
        return
      end
      project = project_builder.run
      @template["Resources"].merge!(project)

      if project["CodeBuild"]["Properties"]["ServiceRole"] == {"Ref"=>"IamRole"}
        role = Role.new(@options).run
        @template["Resources"].merge!(role)
      end

      template_path = "/tmp/codebuild.yml"
      FileUtils.mkdir_p(File.dirname(template_path))
      IO.write(template_path, YAML.dump(@template))
      puts "Generated CloudFormation template at #{template_path.color(:green)}"
      return if @options[:noop]
      puts "Deploying stack #{@stack_name.color(:green)} with CodeBuild project #{@full_project_name.color(:green)}"

      begin
        perform
        url_info
        status.wait
        exit 2 unless status.success?
      rescue Aws::CloudFormation::Errors::ValidationError => e
        if e.message.include?("No updates") # No updates are to be performed.
          puts "WARN: #{e.message}".color(:yellow)
        else
          puts "ERROR: #{e.message}".color(:red)
          exit 1
        end
      end
    end

  private
    def url_info
      stack = cfn.describe_stacks(stack_name: @stack_name).stacks.first
      region = `aws configure get region`.strip rescue "us-east-1"
      url = "https://console.aws.amazon.com/cloudformation/home?region=#{region}#/stacks"
      puts "Stack name #{@stack_name.color(:yellow)} status #{stack["stack_status"].color(:yellow)}"
      puts "Here's the CloudFormation url to check for more details #{url}"
    end

    def status
      @status ||= Cfn::Status.new(@stack_name)
    end
  end
end
