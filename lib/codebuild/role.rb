require "yaml"

module Codebuild
  class Role
    include Codebuild::Dsl::Role
    include Evaluate

    def initialize(options={})
      @options = options
      @role_path = options[:role_path] || ".codebuild/role.rb"
      @properties = default_properties
    end

    def run
      puts "Evaluating .codebuild/role.rb DSL"
      evaluate(@role_path)
      @properties[:policies] = [{
        policy_name: "CodeBuildAccess",
        policy_document: {
          version: "2012-10-17",
          statement: [derived_statement]
        }
      }]
      resource = {
        IamRole: {
          type: "AWS::IAM::Role",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

  private
    def default_properties
      {
        assume_role_policy_document: {
          statement: [{
            action: ["sts:AssumeRole"],
            effect: "Allow",
            principal: {
              service: ["codebuild.amazonaws.com"]
            }
          }],
          version: "2012-10-17"
        },
        path: "/"
      }
    end

    def derived_statement
      @iam_statement || {
        action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        effect: "Allow",
        resource: "*"
      }
    end
  end
end
