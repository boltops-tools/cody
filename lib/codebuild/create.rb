module Codebuild
  class Create < Stack
    def perform
      cfn.create_stack(
        stack_name: @stack_name,
        template_body: YAML.dump(@template),
        capabilities: ["CAPABILITY_IAM"]
      )
    end
  end
end
