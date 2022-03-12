module Cody::Builder::Evaluate
  module Interface
    # Useful interface methods if want to run more generalized code in the evaluated DSL files
    def project_name
      @options["project_name"]
    end

    def full_project_name
      @options["full_project_name"]
    end
  end
end
