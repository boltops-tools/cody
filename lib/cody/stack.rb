require "aws-sdk-cloudformation"

module Cody
  class Stack
    include Cody::AwsServices

    def initialize(options)
      @options = options
      @project_name = @options[:project_name] || inferred_project_name
      @stack_name = normalize_stack_name(options[:stack_name] || inferred_stack_name(@project_name))
    end

    def run
      handle_rollback_completed!
      if stack_exists?(@stack_name)
        Update.new(@options).run
      else
        Create.new(@options).run
      end
    end

  private
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
  end
end
