require "yaml"

module Codebuild
  class Project
    include Codebuild::Dsl::Project
    include Evaluate

    def initialize(options={})
      @options = options
      @project_path = options[:project_path] || ".codebuild/project.rb"
      # These defaults make it the project.rb simpler
      @properties = default_properties
    end

    def run
      puts "Evaluating .codebuild/project.rb DSL"
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
      }
    end
  end
end
