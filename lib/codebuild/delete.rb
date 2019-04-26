module Codebuild
  class Delete
    include AwsServices

    def initialize(options)
      @options = options
      @stack_name = options[:stack_name] || inferred_stack_name
    end

    def run
      message = "Deleted #{@stack_name} stack."
      if @options[:noop]
        puts "NOOP #{message}"
      else
        are_you_sure?(@stack_name, :delete)

        if stack_exists?(@stack_name)
          cfn.delete_stack(stack_name: @stack_name)
          puts message
        else
          puts "#{@stack_name.inspect} stack does not exist".color(:red)
        end
      end
    end
  end
end
