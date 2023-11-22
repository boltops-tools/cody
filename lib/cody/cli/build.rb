class Cody::CLI
  class Build < Base
    def initialize(options={})
      super
      @template = {
        "Description" => "CodeBuild Project: #{@full_project_name}",
        "Resources" => {}
      }
    end

    def template
      project_resource = Cody::Project.new(@options).build
      @template["Resources"].merge!(project_resource)
      puts "template1:"
      pp @template

      if project_resource["CodeBuild"]["Properties"]["ServiceRole"] == {"Ref"=>"IamRole"}
        role_resource = Cody::Role.new(@options).build
        @template["Resources"].merge!(role_resource)
      end

      puts "template2:"
      pp @template

      schedule_resource = Cody::Schedule.new(@options).build
      @template["Resources"].merge!(schedule_resource) if schedule_resource

      puts "template3:"
      pp @template

      write
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
