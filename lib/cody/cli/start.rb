class Cody::CLI
  class Start < Base
    def run
      are_you_sure?

      params = { project_name: project_name }
      source_version = @options[:branch]
      params[:source_version] = source_version if source_version # when nil. uses branch configured on CodeBuild project settings
      params[:secondary_sources_version_override] = secondary_sources_version_override if secondary_sources_version_override # when nil. uses branch configured on CodeBuild project settings
      params[:environment_variables_override] = environment_variables_override if @options[:env_vars]
      params.merge!(@options[:overrides]) if @options[:overrides]
      branch_info
      logger.debug("params: #{params}")
      resp = codebuild.start_build(params)

      logger.info "Build started for project #{project_name}"
      logger.info "Console Log Url:"
      logger.info codebuild_log_url(resp.build.id)
      tail_logs(resp.build.id) if @options[:wait]
    end

    def tail_logs(build_id)
      Cody::Tailer.new(@options, build_id).run
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

    def branch_info
      if @options[:branch]
        logger.info "Branch: #{@options[:branch]}"
      end
      if @options[:secondary_branches]
        logger.info "Branches: #{@options[:secondary_branches]}"
      end
    end

    # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CodeBuild/Client.html#start_build-instance_method
    # Map Hash to secondary_sources_version_override Structure. IE:
    # From: {Main: "feature1"}
    # To: [{source_identifier: "Main", source_version: "feature"}]
    def secondary_sources_version_override
      secondary_branches = @options[:secondary_branches]
      return unless secondary_branches
      secondary_branches.map do |id, version|
        {source_identifier: id, source_version: version}
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
        message = "ERROR: Unable to find the codebuild project with either full_project_name: #{@full_project_name} or project_name: #{@project_name}"
        if @options[:raise_error]
          raise(message)
        else
          logger.info message.color(:red)
          exit 1
        end
      end
    end

  private
    def are_you_sure?
      message = "Will start build for project #{project_name.color(:green)}#{stack_message}"
      if @options[:yes]
        logger.info message
      else
        sure?(message)
      end
    end

    # In case cody start is used with CodeBuild projects not created by Cody and CloudFormation
    def stack_message
      # Will start build for stack CodeBuild-4X23QbVjeWuo-cody project CodeBuild-4X23QbVjeWuo
      stack = find_stack(@stack_name)
      " stack #{@stack_name.color(:green)}" if stack
    end

    def codebuild_log_url(build_id)
      build_id = build_id.split(':').last
      "https://#{region}.console.aws.amazon.com/codesuite/codebuild/projects/#{project_name}/build/#{project_name}%3A#{build_id}/log"
    end

    def project_exists?(name)
      resp = codebuild.batch_get_projects(names: [name])
      resp.projects.size > 0
    end
  end
end
