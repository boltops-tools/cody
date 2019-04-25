module Codebuild::Dsl
  module Project
    autoload :Ssm, "codebuild/dsl/project/ssm"
    include Ssm

    PROPERTIES = %w[
      artifacts
      badge_enabled
      cache
      description
      encryption_key
      environment
      logs_config
      name
      queued_timeout_in_minutes
      secondary_artifacts
      secondary_sources
      service_role
      source
      tags
      timeout_in_minutes
      triggers
      vpc_config
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
        @properties[prop.to_sym] = v
      end
    end

    # convenience wrapper methods

    def github_url(url)
      # Sets a baseline default first
      github_source(location: url) unless @properties[:source]
      # Always overrides
      @properties[:source][:location] = url
    end

    def github_token(token)
      # Sets a baseline default first
      github_source(oauth_token: token) unless @properties[:source]
      # Always overrides
      @properties[:source][:auth][:resource] = token
    end

    def github_source(options={})
      source = {
        type: "GITHUB",
        location: options[:location],
        git_clone_depth: 1,
        git_submodules_config: { fetch_submodules: true },
        build_spec: options[:buildspec] || ".codebuild/buildspec.yml",
        auth: {
          type: "OAUTH",
          resource: options[:oauth_token],
        },
        report_build_status: true,
      }
      @properties[:source] = source
    end

    def linux_image(name)
      linux_environment(image: name)
    end

    def linux_environment(options={})
      image = options[:image] || "aws/codebuild/ruby:2.5.3-1.7.0"
      environment = {
        compute_type: options[:compute_type] || "BUILD_GENERAL1_SMALL",
        image_pull_credentials_type: "CODEBUILD", # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-environment.html#cfn-codebuild-project-environment-imagepullcredentialstype
        privileged_mode: true,
        image: image,
        type: "LINUX_CONTAINER"
      }
      environment[:environment_variables] = @mapped_env_vars if @mapped_env_vars
      @properties[:environment] = environment
    end

    def environment_variables(vars)
      @env_vars = vars
      @mapped_env_vars = @env_vars.map { |k,v|
        k = k.to_s
        if v =~ /^ssm:/
          { type: "PARAMETER_STORE", name: k, value: v.sub('ssm:','') }
        else
          { type: "PLAINTEXT", name: k, value: v }
        end
      }
      @properties[:environment] ||= {}
      @properties[:environment][:environment_variables] = @mapped_env_vars
    end
  end
end
