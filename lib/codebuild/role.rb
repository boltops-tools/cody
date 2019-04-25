require "yaml"

module Codebuild
  class Role
    include Codebuild::Dsl::Role
    include Evaluate

    def initialize(options={})
      @options = options
      @role_path = options[:role_path] || ".codebuild/role.rb"
      @properties = default_properties
      @iam_policy = {}
    end

    def run
      evaluate(@role_path)
      @properties[:policies] = [{
        policy_name: "CodeBuildAccess",
        policy_document: {
          version: "2012-10-17",
          statement: derived_iam_statements
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

    def derived_iam_statements
      @iam_statements || default_iam_statements
    end

    def default_iam_statements
      [{
        action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:DescribeDocumentParameters",
          "ssm:DescribeParameters",
          "ssm:GetParameter*",
        ],
        effect: "Allow",
        resource: "*"
      }]
    end
  end
end
