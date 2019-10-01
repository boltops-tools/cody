module Cody::Dsl
  module Project
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

    # Convenience wrapper methods
    def github_url(url)
      @properties[:source][:location] = url
    end

    # So it looks like the auth resource property doesnt really get used.
    # Instead an account level credential is worked.  Refer to:
    # https://github.com/tongueroo/cody/blob/master/readme/github_oauth.md
    #
    # Keeping this method around in case the CloudFormation method works one day,
    # or end up figuring out to use it properly.
    def github_token(token)
      @properties[:source][:auth][:resource] = token
    end

    def github_source(options={})
      source = {
        type: "GITHUB",
        location: options[:location],
        git_clone_depth: 1,
        git_submodules_config: { fetch_submodules: true },
        build_spec: options[:buildspec] || ".codebuild/buildspec.yml", # options[:buildspec] accounts for type already
        report_build_status: true,
      }

      if options[:oauth_token]
        source[:auth] = {
          type: "OAUTH",
          resource: options[:oauth_token],
        }
      end

      @properties[:source] = source
    end

    def linux_image(name)
      linux_environment(image: name)
    end

    def linux_environment(options={})
      image = options[:image] || "aws/codebuild/ruby:2.5.3-1.7.0"
      env = {
        compute_type: options[:compute_type] || "BUILD_GENERAL1_SMALL",
        image_pull_credentials_type: "CODEBUILD", # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-environment.html#cfn-codebuild-project-environment-imagepullcredentialstype
        privileged_mode: true,
        image: image,
        type: "LINUX_CONTAINER"
      }
      # @mapped_env_vars is in memory
      env[:environment_variables] = @mapped_env_vars if @mapped_env_vars
      # options has highest precedence
      env[:environment_variables] = options[:environment_variables] if options[:environment_variables]
      @properties[:environment] = env
    end

    def environment_variables(vars)
      # Storing @mapped_env_vars as instance variable for later usage in linux_environment
      @mapped_env_vars = vars.map { |k,v|
        k, v = k.to_s, v.to_s
        if v =~ /^ssm:/
          { type: "PARAMETER_STORE", name: k, value: v.sub('ssm:','') }
        else
          { type: "PLAINTEXT", name: k, value: v }
        end
      }
      @properties[:environment] ||= {}
      @properties[:environment][:environment_variables] = @mapped_env_vars
    end

    def local_cache(enable=true)
      cache = if enable
        {
          type: "LOCAL",
          modes: [
              "LOCAL_DOCKER_LAYER_CACHE",
              "LOCAL_SOURCE_CACHE",
              "LOCAL_CUSTOM_CACHE"
          ]
        }
      else
        {type: "NO_CACHE"}
      end
      @properties[:cache] = cache
    end

    def type
      @options[:type]
    end
  end
end
