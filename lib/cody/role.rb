require "yaml"

module Cody
  class Role < Dsl::Base
    include Evaluate
    include Variables
    include Dsl::Role

    def initialize(options={})
      super
      @role_path = options[:role_path] || get_role_path
      @iam_policy = {}
    end

    def run
      load_variables
      evaluate_file(@role_path) if File.exist?(@role_path) # registers definitions to registry
      build # build definitions from registry. can set: @iam_statements and @managed_policy_arns
      @properties[:Policies] = [{
        PolicyName: "CodeBuildAccess",
        PolicyDocument: {
          Version: "2012-10-17",
          Statement: derived_iam_statements
        }
      }]

      @properties[:ManagedPolicyArns] ||= @managed_policy_arns || default_managed_policy_arns

      resource = {
        IamRole: {
          Type: "AWS::IAM::Role",
          Properties: @properties
        }
      }
      auto_camelize(resource)
    end

  private
    Registry = Cody::Dsl::Role::Registry
    def build
      @iam_statements = Registry.iam_statements if Registry.iam_statements
      @managed_policy_arns = Registry.managed_policy_arns if Registry.managed_policy_arns
    end

    def get_role_path
      lookup_cody_file("role.rb")
    end

    def default_properties
      {
        AssumeRolePolicyDocument: {
          Statement: [{
            Action: ["sts:AssumeRole"],
            Effect: "Allow",
            Principal: {
              Service: ["codebuild.amazonaws.com"]
            }
          }],
          Version: "2012-10-17"
        },
        Path: "/"
      }
    end

    def derived_iam_statements
      @iam_statements || default_iam_statements
    end

    def default_iam_statements
      [{
        Action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:DescribeDocumentParameters",
          "ssm:DescribeParameters",
          "ssm:GetParameter*",
        ],
        Effect: "Allow",
        Resource: "*"
      }]
    end

    def default_managed_policy_arns
      # Useful when using with CodePipeline
      ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
    end
  end
end
