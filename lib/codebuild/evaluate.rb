module Codebuild
  module Evaluate
    def evaluate(path)
      source_code = IO.read(path)
      begin
        instance_eval(source_code, path)
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

    def lookup_codebuild_file(name)
      folder_path = [".codebuild", @options[:lookup], name].compact.join("/")
      if File.exist?(folder_path)
        folder_path
      else
        ".codebuild/#{name}" # default
      end
    end
  end
end
