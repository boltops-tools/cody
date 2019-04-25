require "aws-sdk-cloudformation"

module Codebuild
  class Stack
    def initialize(options)
      @options = options
      @stack_name = options[:stack_name] || inferred_stack_name
      @template = {"Resources" => {} }
    end

    def run
      project = Project.new(@options).run
      role = Role.new(@options).run
      @template["Resources"]
        .merge!(project)
        .merge!(role)
      puts YAML.dump(@template)
      begin
        perform
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR: #{e.message}".color(:red)
        exit 1
      end
    end

    def inferred_stack_name
      name = File.basename(Dir.pwd).gsub('_','-').gsub(/[^0-9a-zA-Z,-]/, '')
      name += "-codebuild" unless name.include?("-codebuild")
      name
    end

    def stack_name
      random = (0...8).map { (65 + rand(26)).chr }.join
      "test-project-#{random}"
    end

    def cfn
      @cfn ||= Aws::CloudFormation::Client.new
    end
  end
end
