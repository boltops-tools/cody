module Codebuild
  class Deploy < Stack
    def run
      handle_rollback_completed!
      if stack_exists?(@stack_name)
        Update.new(@options).run
      else
        Create.new(@options).run
      end
    end

    def handle_rollback_completed!
      @stack = find_stack(@stack_name)
      if @stack && rollback_complete?(@stack)
        puts "Existing stack in ROLLBACK_COMPLETE state. Deleting stack before continuing."
        cfn.delete_stack(stack_name: @stack_name)
        status.wait
        status.reset
        @stack = nil # at this point stack has been deleted
      end
    end

    def rollback_complete?(stack)
      stack.stack_status == 'ROLLBACK_COMPLETE'
    end

    def find_stack(stack_name)
      return if ENV['TEST']
      resp = cfn.describe_stacks(stack_name: stack_name)
      resp.stacks.first
    rescue Aws::CloudFormation::Errors::ValidationError => e
      # example: Stack with id demo-web does not exist
      if e.message =~ /Stack with/ && e.message =~ /does not exist/
        nil
      else
        raise
      end
    end
  end
end
