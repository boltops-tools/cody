class Cody::Stack
  class Create < Base
    def perform
      template_body = YAML.dump(@template)
      puts "template_body:"
      puts template_body
      cfn.create_stack(
        stack_name: @stack_name,
        template_body: template_body,
        capabilities: ["CAPABILITY_IAM"]
      )
      puts "Creating stack #{@stack_name}. Check CloudFormation console for status."
    end
  end
end
