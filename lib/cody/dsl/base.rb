module Cody::Dsl
  class Base < Cody::CLI::Base
    include Evaluate
    include Variables

    attr_reader :options, :project_name, :full_project_name, :type
    def initialize(options={})
      super
      @type = options[:type]
      @properties = default_properties # defaults make project.rb simpler
    end

    # In v1.0.0 defaults to not auto-camelize
    def auto_camelize(data)
      if Cody.config.auto_camelize
        CfnCamelizer.transform(data)
      else
        data.deep_stringify_keys!
      end
    end
  end
end
