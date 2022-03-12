class Cody::CLI
  class Delete < Base
    include Cody::AwsServices

    def run
      are_you_sure?(@stack_name, :delete)
      unless stack_exists?(@stack_name)
        logger.info "#{@stack_name.inspect} stack does not exist".color(:red)
        exit 1
      end

      cfn.delete_stack(stack_name: @stack_name)
      logger.info "Deleted #{@stack_name} stack."
    end
  end
end
