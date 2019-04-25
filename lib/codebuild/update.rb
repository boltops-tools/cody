module Codebuild
  class Update < Stack
    def perform
      cfn.update_stack(
        stack_name: @stack_name,
        template_body: YAML.dump(@template),
        capabilities: ["CAPABILITY_IAM"]
      )
      puts "Updating stack #{@stack_name}. Check CloudFormation console for status."
    end
  end
end
