class Cody::Stack
  class Update < Base
    def perform
      cfn.update_stack(
        stack_name: @stack_name,
        template_body: YAML.dump(@template),
        capabilities: ["CAPABILITY_IAM"]
      )
      puts "Updating stack #{@stack_name}"
    end
  end
end
