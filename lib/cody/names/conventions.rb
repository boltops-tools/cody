module Cody::Names
  module Conventions
    def project_name_convention(name_base)
      items = [@project_name, @options[:type], Cody.extra]
      items.insert(2, Cody.env) if Cody.config.names.append_env
      items.reject(&:blank?).compact.join("-")
    end

    def inferred_project_name
      # Essentially the project's parent folder
      File.basename(Dir.pwd).gsub('_','-').gsub(/\.+/,'-').gsub(/[^0-9a-zA-Z,-]/, '')
    end

    # Examples:
    #
    #     myapp-ci-deploy # with Settings stack_naming append_env set to false.
    #     myapp-ci-deploy-development
    #     myapp-ci-deploy-development-2
    #
    def inferred_stack_name(project_name)
      append_stack_name = Cody.config.names.append_stack_name # IE: cody
      items = [project_name, @options[:type], Cody.extra, append_stack_name]
      items.insert(3, Cody.env) if Cody.config.names.append_env
      items.reject(&:blank?).reject {|i| i == false}.compact.join("-")
    end

    def normalize_stack_name(name)
      name.gsub('_','-') # cloudformation stack names dont allow _
    end
  end
end
