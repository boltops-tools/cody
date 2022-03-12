module Cody
  class Builder < Cody::CLI::Base
    def initialize(options={})
      super
      @template = {
        "Description" => "CodeBuild Project: #{@full_project_name}",
        "Resources" => {}
      }
    end

    def template
      source_credential = SourceCredential.new(@options).build
      @template["Resources"].merge!(source_credential) if source_credential

      project_resource = Project.new(@options).build
      @template["Resources"].merge!(project_resource)
      if source_credential
        @template["Resources"]["CodeBuild"]["DependsOn"] = "SourceCredential"
      end

      if project_resource["CodeBuild"]["Properties"]["ServiceRole"] == {"Ref"=>"IamRole"}
        iam_role_resource = IamRole.new(@options).build
        @template["Resources"].merge!(iam_role_resource)
      end

      schedule_resource = Schedule.new(@options).build
      @template["Resources"].merge!(schedule_resource) if schedule_resource

      write
      @template
    end
    alias_method :run, :template

    def write
      template_path = ".cody/output/template.yml"
      FileUtils.mkdir_p(File.dirname(template_path))
      IO.write(template_path, YAML.dump(@template))
      logger.info "Template built: #{pretty_path(template_path)}"
    end
  end
end
