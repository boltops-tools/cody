module Cody::Dsl
  class Base
    attr_reader :project_name, :full_project_name
    def initialize(options={})
      @options = options
      @project_name = options[:project_name]
      @full_project_name = options[:full_project_name] # includes -development at the end
      @properties = default_properties # defaults make project.rb simpler
    end

    # In v1.0.0 defaults to not auto-camelize
    def auto_camelize(data)
      if Cody.settings[:auto_camelize]
        CfnCamelizer.transform(data)
      else
        data.deep_stringify_keys!
      end
    end
  end
end
