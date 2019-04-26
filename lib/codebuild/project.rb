require "yaml"

module Codebuild
  class Project
    include Dsl::Project
    include Evaluate

    def initialize(options={})
      @options = options
      @project_path = options[:project_path] || ".codebuild/project.rb"
      # These defaults make it the project.rb simpler
      @properties = default_properties
    end

    def run
      evaluate(@project_path)
      resource = {
        code_build: {
          type: "AWS::CodeBuild::Project",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

    def default_properties
      {
        artifacts: { type: "NO_ARTIFACTS" },
        service_role: { ref: "IamRole" },
        badge_enabled: true,
        timeout_in_minutes: 20,
        logs_config: {
          cloud_watch_logs: {
            status: "ENABLED",
            # the default log group name is thankfully the project name
          }
        },
        cache: {
          type: "LOCAL",
          modes: [
              "LOCAL_DOCKER_LAYER_CACHE",
              "LOCAL_SOURCE_CACHE",
              "LOCAL_CUSTOM_CACHE"
          ]
        },
        source: {
          type: "GITHUB",
          # location: "", # required
          git_clone_depth: 1,
          git_submodules_config: { fetch_submodules: true },
          build_spec: ".codebuild/buildspec.yml",
          auth: {
            type: "OAUTH",
            resource: "", # required
          },
          report_build_status: true,
        }
      }
    end
  end
end
