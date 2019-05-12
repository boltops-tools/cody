module Codebuild::AwsServices
  module Helpers
    def stack_exists?(stack_name)
      return false if ENV['TEST']

      exist = nil
      begin
        # When the stack does not exist an exception is raised. Example:
        # Aws::CloudFormation::Errors::ValidationError: Stack with id blah does not exist
        cfn.describe_stacks(stack_name: stack_name)
        exist = true
      rescue Aws::CloudFormation::Errors::ValidationError => e
        if e.message =~ /does not exist/
          exist = false
        elsif e.message.include?("'stackName' failed to satisfy constraint")
          # Example of e.message when describe_stack with invalid stack name
          # "1 validation error detected: Value 'instance_and_route53' at 'stackName' failed to satisfy constraint: Member must satisfy regular expression pattern: [a-zA-Z][-a-zA-Z0-9]*|arn:[-a-zA-Z0-9:/._+]*"
          puts "Invalid stack name: #{stack_name}"
          puts "Full error message: #{e.message}"
          exit 1
        else
          raise # re-raise exception  because unsure what other errors can happen
        end
      end
      exist
    end

    def inferred_stack_name
      File.basename(Dir.pwd).gsub('_','-').gsub(/\.+/,'-').gsub(/[^0-9a-zA-Z,-]/, '')
    end

    def are_you_sure?(stack_name, action)
      if @options[:sure]
        sure = 'y'
      else
        message = case action
        when :update
          "Are you sure you want to want to update the #{stack_name.color(:green)} stack with the changes? (y/N)"
        when :delete
          "Are you sure you want to want to delete the #{stack_name.color(:green)} stack? (y/N)"
        end
        puts message
        sure = $stdin.gets
      end

      unless sure =~ /^y/
        puts "Whew! Exiting without running #{action}."
        exit 0
      end
    end
  end
end