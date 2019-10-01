module Codebuild
  module Variables
    def load_variables
      load_variables_file("base")
      load_variables_file(Codebuild.env)
      # Then load type scope variables, so they take higher precedence
      load_variables_file("base", @options[:type])
      load_variables_file(Codebuild.env, @options[:type])
    end

    def load_variables_file(filename, type=nil)
      items = ["#{Codebuild.root}/.codebuild", type, "variables/#{filename}.rb"].compact
      path = items.join('/')
      instance_eval(IO.read(path), path) if File.exist?(path)
    end
  end
end
