module Codebuild
  class Deploy < Stack
    def run
      if stack_exists?(@stack_name)
        Update.new(@options).run
      else
        Create.new(@options).run
      end
    end
  end
end
