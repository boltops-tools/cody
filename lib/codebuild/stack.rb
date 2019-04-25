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

      puts "Generated CloudFormation template:"
      puts YAML.dump(@template)
      return if @options[:noop]

      begin
        perform
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR: #{e.message}".color(:red)
        exit 1
      end
    end
  end
end
