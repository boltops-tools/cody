require "yaml"

module Cody
  class Project < Dsl::Base
    include Dsl::Project
    include Evaluate
    include Variables

    attr_reader :project_path
    def initialize(options={})
      super
      @project_path = options[:project_path] || get_project_path
    end

    def exist?
      File.exist?(@project_path)
    end

    def run
      load_variables
      evaluate(@project_path)
      resource = {
        CodeBuild: {
          Type: "AWS::CodeBuild::Project",
          Properties: @properties
        }
      }
      auto_camelize(resource)
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
          ReportBuildStatus: true,
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
