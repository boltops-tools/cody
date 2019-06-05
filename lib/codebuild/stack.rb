require "aws-sdk-cloudformation"

module Codebuild
  class Stack
    include AwsServices

    def initialize(options)
      @options = options
      @stack_name = options[:stack_name] || inferred_stack_name
      @template = {"Resources" => {} }
    end

    def run
      project = Project.new(@options).run
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

      begin
        perform
        url_info
        status.wait
        exit 2 unless status.success?
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR: #{e.message}".color(:red)
        exit 1
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
