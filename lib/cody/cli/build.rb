class Cody::CLI
  class Build < Base
    extend Memoist

    def run
      check_exist!
      project = project_builder.run
      pp project
    end

    def check_exist!
      return if project_builder.exist?
      logger.error "ERROR: Cody project does not exist: #{project_builder.project_path}".color(:red)
      exit 1
    end

    def project_builder
      Cody::Project.new(@options)
    end
    memoize :project_builder
  end
end
