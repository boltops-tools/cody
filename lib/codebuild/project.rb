require "yaml"

module Codebuild
  class Project
    include Dsl::Project
    include Evaluate

    attr_reader :project_name, :full_project_name, :project_path
    def initialize(options={})
      @options = options
      @project_name = options[:project_name]
      @full_project_name = options[:full_project_name] # includes -development at the end
      @project_path = options[:project_path] || get_project_path
      @properties = default_properties # defaults make project.rb simpler
    end

    def exist?
      File.exist?(@project_path)
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
        name: @full_project_name,
        description: @full_project_name,
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
        source: {
          type: "GITHUB",
          # location: "", # required
          # git_clone_depth: 1,
          git_submodules_config: { fetch_submodules: true },
          build_spec: build_spec,
          # auth doesnt seem to work, refer to https://github.com/tongueroo/codebuild/blob/master/readme/github_oauth.md
          # auth: {
          #   type: "OAUTH",
          #   # resource: "", # required
          # },
          report_build_status: true,
        }
      }
    end

    def get_project_path
      lookup_codebuild_file("project.rb")
    end

    def build_spec
      lookup_codebuild_file("buildspec.yml")
    end
  end
end
