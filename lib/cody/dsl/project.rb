module Cody::Dsl
  module Project
    include Git
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

    def buildspec(file=".cody/buildspec.yaml")
      @properties[:Source][:BuildSpec] = file
    end
    alias_method :build_spec, :buildspec

    def image(name)
      environment(Image: name)
    end

    def environment(options={})
      image = options[:Image] || Cody::DEFAULT_IMAGE
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
      @options[:type] # :type is lowercase since it's a CLI option
    end
  end
end
