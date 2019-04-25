require "yaml"

module Codebuild
  class Role
    include Codebuild::Dsl::Role
    include Evaluate

    def initialize(options={})
      @options = options
      @role_path = options[:role_path] || ".codebuild/role.rb"
      @properties = {}
    end

    def run
      puts "Evaluating .codebuild/role.rb DSL"
      evaluate(@role_path)
      resource = {
        IamRole: {
          type: "AWS::IAM::Role",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end
  end
end
