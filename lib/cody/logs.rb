module Cody
  class Logs < Base
    def run
      unless build_id
        puts "WARN: No builds found for #{@project_name.color(:green)} project"
        return
      end

      run_with_exception_handling do
        Tailer.new(@options, build_id).run
      end
    end
  end
end
