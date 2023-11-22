class Cody::Stack
  class Base
    include Cody::AwsServices
    include Status

    def initialize(options={})
      @options = options
      @project_name = @options[:project_name] || inferred_project_name
      @stack_name = normalize_stack_name(options[:stack_name] || inferred_stack_name(@project_name))

      @full_project_name = project_name_convention(@project_name)
    end

    def run
      options = @options.merge(
        project_name: @project_name,
        full_project_name: @full_project_name,
      )
      @template = Cody::CLI::Build.new(@options).template

      return if @options[:noop]
      puts "Deploying stack #{@stack_name.color(:green)} with CodeBuild project #{@full_project_name.color(:green)}"

      begin
        perform
        url_info
        return unless @options[:wait]
        status.wait
        exit 2 unless status.success?
      rescue Aws::CloudFormation::Errors::ValidationError => e
        if e.message.include?("No updates") # No updates are to be performed.
          puts "WARN: #{e.message}".color(:yellow)
        else
          puts "ERROR ValidationError: #{e.message}".color(:red)
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

    def rollback_complete?(stack)
      stack.stack_status == 'ROLLBACK_COMPLETE'
    end


    def handle_rollback_completed!
      @stack = find_stack(@stack_name)
      if @stack && rollback_complete?(@stack)
        puts "Existing stack in ROLLBACK_COMPLETE state. Deleting stack before continuing."
        cfn.delete_stack(stack_name: @stack_name)
        status.wait
        status.reset
        @stack = nil # at this point stack has been deleted
      end
    end

    def find_stack(stack_name)
      return if ENV['TEST']
      resp = cfn.describe_stacks(stack_name: stack_name)
      resp.stacks.first
    rescue Aws::CloudFormation::Errors::ValidationError => e
      # example: Stack with id demo-web does not exist
      if e.message =~ /Stack with/ && e.message =~ /does not exist/
        nil
      else
        raise
      end
    end
  end
end
