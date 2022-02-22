class Cody::Stack
  class Base
    include Cody::AwsServices
    include Status

    def initialize(options)
      @options = options
      @project_name = @options[:project_name] || inferred_project_name
      @stack_name = normalize_stack_name(options[:stack_name] || inferred_stack_name(@project_name))

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
      project_builder = Cody::Project.new(options)
      unless project_builder.exist?
        puts "ERROR: Cody project does not exist: #{project_builder.project_path}".color(:red)
        exit 1
        return
      end
      project = project_builder.run
      @template["Resources"].merge!(project)

      if project["CodeBuild"]["Properties"]["ServiceRole"] == {"Ref"=>"IamRole"}
        role = Cody::Role.new(options).run
        @template["Resources"].merge!(role)
      end

      schedule = Cody::Schedule.new(options).run
      @template["Resources"].merge!(schedule) if schedule

      template_path = "/tmp/codebuild.yml"
      FileUtils.mkdir_p(File.dirname(template_path))
      IO.write(template_path, YAML.dump(@template))
      puts "Generated CloudFormation template at #{template_path.color(:green)}"
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
