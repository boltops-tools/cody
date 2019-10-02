module Cody
  class Create < Stack
    def perform
      cfn.create_stack(
        stack_name: @stack_name,
        template_body: YAML.dump(@template),
        capabilities: ["CAPABILITY_IAM"]
      )
      puts "Creating stack #{@stack_name}. Check CloudFormation console for status."
    end
  end
end
