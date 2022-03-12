class Cody::Builder
  class Project < Cody::Dsl::Base
    include Cody::Dsl::Project

    def initialize(options={})
      super
      @project_path = options[:project_path] || get_project_path
    end

    def build
      check_exist!
      load_variables
      evaluate_file(@project_path)
      resource = {
        CodeBuild: {
          Type: "AWS::CodeBuild::Project",
          Properties: @properties
        }
      }
      auto_camelize(resource)
    end

    def check_exist!
      return if File.exist?(@project_path)
      logger.error "ERROR: Cody project does not exist: #{@project_path}".color(:red)
      exit 1
    end

    def default_properties
      {
        Name: @full_project_name,
        Description: @full_project_name,
        Artifacts: { Type: "NO_ARTIFACTS" },
        ServiceRole: { Ref: "IamRole" },
        BadgeEnabled: true,
        TimeoutInMinutes: 20,
        LogsConfig: {
          CloudWatchLogs: {
            Status: "ENABLED",
            # the default log group name is thankfully the project name
          }
        },
        Source: {
          Type: "GITHUB",
          # location: "", # required
          # GitCloneDepth: 1,
          GitSubmodulesConfig: { FetchSubmodules: true },
          BuildSpec: build_spec,
          # auth doesnt seem to work, refer to https://github.com/tongueroo/cody/blob/master/readme/GithubOauth.md
          # Auth: {
          #   Type: "OAUTH",
          #   # Resource: "", # required
          # },
        }
      }
    end

    def get_project_path
      lookup_cody_file("project.rb")
    end

    def build_spec
      lookup_cody_file("buildspec.yml")
    end
  end
end
