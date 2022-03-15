module Cody::Dsl
  module Project
    include Ssm

    PROPERTIES = %w[
      Artifacts
      BadgeEnabled
      Cache
      Description
      EncryptionKey
      Environment
      LogsConfig
      Name
      QueuedTimeoutInMinutes
      SecondaryArtifacts
      SecondarySources
      ServiceRole
      Source
      Tags
      TimeoutInMinutes
      Triggers
      VpcConfig
    ]
    PROPERTIES.each do |prop|
      define_method(prop.underscore) do |v|
        @properties[prop.to_sym] = v
      end
    end

    # Convenience wrapper methods
    def github_url(url)
      @properties[:Source][:Location] = url
    end

    # Convenience wrapper methods
    def git_provider(type="GITHUB")
      @properties[:Source][:Type] = type
    end

    # Convenience wrapper methods
    def branch(branch_or_tag)
      @properties[:SourceVersion] = branch_or_tag
    end
    alias_method :git_branch, :branch

    def buildspec(file=".cody/buildspec.yaml")
      @properties[:Source][:BuildSpec] = file
    end
    alias_method :build_spec, :buildspec

    # So it looks like the auth resource property doesnt really get used.
    # Instead an account level credential is worked.  Refer to:
    # https://github.com/tongueroo/cody/blob/master/readme/github_oauth.md
    #
    # Keeping this method around in case the CloudFormation method works one day,
    # or end up figuring out to use it properly.
    def github_token(token)
      @properties[:Source][:Auth][:Resource] = token
    end

    def github_source(options={})
      source = {
        Type: options[:Type] || "GITHUB",
        Location: options[:Location],
        GitCloneDepth: 1,
        GitSubmodulesConfig: { fetch_submodules: true },
        BuildSpec: options[:BuildSpec] || ".cody/buildspec.yml", # options[:Buildspec] accounts for type already
      }

      if source[:Type] =~ /GITHUB/
        source[:ReportBuildStatus] = true
      end

      if options[:OauthToken]
        source[:Auth] = {
          Type: "OAUTH",
          Resource: options[:OauthToken],
        }
      end

      @properties[:Source] = source
    end

    def linux_image(name)
      linux_environment(Image: name)
    end

    def linux_environment(options={})
      image = options[:Image] || "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
      env = {
        ComputeType: options[:ComputeType] || "BUILD_GENERAL1_SMALL",
        ImagePullCredentialsType: "CODEBUILD", # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-environment.html#cfn-codebuild-project-environment-imagepullcredentialstype
        PrivilegedMode: true,
        Image: image,
        Type: "LINUX_CONTAINER"
      }
      # @mapped_env_vars is in memory
      env[:EnvironmentVariables] = @mapped_env_vars if @mapped_env_vars
      # options has highest precedence
      env[:EnvironmentVariables] = options[:EnvironmentVariables] if options[:EnvironmentVariables]
      @properties[:Environment] = env
    end

    def environment_variables(vars)
      # Storing @mapped_env_vars as instance variable for later usage in linux_environment
      @mapped_env_vars = vars.map { |k,v|
        k, v = k.to_s, v.to_s
        if v =~ /^ssm:/
          { Type: "PARAMETER_STORE", Name: k, Value: v.sub('ssm:','') }
        else
          { Type: "PLAINTEXT", Name: k, Value: v }
        end
      }
      @properties[:Environment] ||= {}
      @properties[:Environment][:EnvironmentVariables] = @mapped_env_vars
    end
    alias_method :env_vars, :environment_variables

    def local_cache(enable=true)
      cache = if enable
        {
          Type: "LOCAL",
          Modes: [
              "LOCAL_DOCKER_LAYER_CACHE",
              "LOCAL_SOURCE_CACHE",
              "LOCAL_CUSTOM_CACHE"
          ]
        }
      else
        {type: "NO_CACHE"}
      end
      @properties[:Cache] = cache
    end

    def type
      @options[:type] # should be lowercase
    end
  end
end
