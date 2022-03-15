class Cody::Stack
  class Create < Base
    def perform
      template_body = YAML.dump(@template)
      cfn.create_stack(
        stack_name: @stack_name,
        template_body: template_body,
        capabilities: ["CAPABILITY_IAM"]
      )
      puts "Creating stack #{@stack_name}"
    end
  end
end
