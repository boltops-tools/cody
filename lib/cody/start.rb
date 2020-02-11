module Cody
  class Start
    include AwsServices

    def initialize(options)
      @options = options
      @project_name = options[:project_name] || inferred_project_name
      @full_project_name = project_name_convention(@project_name)
    end

    def run
      source_version = @options[:branch] || @options[:source_version] || 'master'
      params = {
        project_name: project_name,
        source_version: source_version
      }
      params[:environment_variables_override] = environment_variables_override if @options[:env_vars]
      resp = codebuild.start_build(params)

      puts "Build started for project: #{project_name}"
      puts "Here's the CodeBuild Console Log url:"
      puts codebuild_log_url(resp.build.id)
      tail_logs(resp.build.id) if @options[:wait]
    end

    def tail_logs(build_id)
      Tailer.new(@options, build_id).run
    end

    def environment_variables_override
      @options[:env_vars].map do |s|
        k, v = s.split('=')
        ssm = false
        if /^ssm:(.*)/.match(v)
          v = $1
          ssm = true
        end

        {
          name: k,
          value: v,
          type: ssm ? "PARAMETER_STORE" : "PLAINTEXT"
        }
      end
    end

    def project_name
      if project_exists?(@full_project_name)
        @full_project_name
      elsif stack_exists?(@project_name) # allow `cody start STACK_NAME` to work too
        resp = cfn.describe_stack_resources(stack_name: @project_name)
        resource = resp.stack_resources.find do |r|
          r.logical_resource_id == "CodeBuild"
        end
        resource.physical_resource_id # codebuild project name
      else
        puts "ERROR: Unable to find the codebuild project with either full_project_name: #{@full_project_name} or project_name: #{@project_name}".color(:red)
        exit 1
      end
    end

  private
    def codebuild_log_url(build_id)
      build_id = build_id.split(':').last
      region = `aws configure get region`.strip rescue "us-east-1"
      region ||= "us-east-1"
      "https://#{region}.console.aws.amazon.com/codesuite/codebuild/projects/#{project_name}/build/#{project_name}%3A#{build_id}/log"
    end

    def project_exists?(name)
      resp = codebuild.batch_get_projects(names: [name])
      resp.projects.size > 0
    end
  end
end
