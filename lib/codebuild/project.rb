require "yaml"

module Codebuild
  class Project
    include Codebuild::Dsl::Project
    include Evaluate

    def initialize(options={})
      @options = options
      @project_path = options[:project_path] || ".codebuild/project.rb"
      # These defaults make it the project.rb simpler
      @properties = {
        artifacts: { type: "NO_ARTIFACTS" },
        service_role: { ref: "IamRole" },
      }
    end

    def run
      puts "Evaluating .codebuild/project.rb DSL"
      evaluate
      resource = {
        code_build: {
          type: "AWS::CodeBuild::Project",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

    def evaluate
      source_code = IO.read(@project_path)
      begin
        instance_eval(source_code, @project_path)
      rescue Exception => e
        if e.class == SystemExit # allow exit to happen normally
          raise
        else
          task_definition_error(e)
          puts "\nFull error:"
          raise
        end
      end
    end

  private
    # Prints out a user friendly task_definition error message
    def task_definition_error(e)
      error_info = e.backtrace.first
      path, line_no, _ = error_info.split(':')
      line_no = line_no.to_i
      puts "Error evaluating #{path}:".color(:red)
      puts e.message
      puts "Here's the line in #{path} with the error:\n\n"

      contents = IO.read(path)
      content_lines = contents.split("\n")
      context = 5 # lines of context
      top, bottom = [line_no-context-1, 0].max, line_no+context-1
      spacing = content_lines.size.to_s.size
      content_lines[top..bottom].each_with_index do |line_content, index|
        line_number = top+index+1
        if line_number == line_no
          printf("%#{spacing}d %s\n".color(:red), line_number, line_content)
        else
          printf("%#{spacing}d %s\n", line_number, line_content)
        end
      end
    end
  end
end
