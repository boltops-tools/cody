module Cody
  class Logs < Base
    def run
      run_with_exception_handling do
        Tailer.new(@options, build_id).run
      end
    end
  end
end
