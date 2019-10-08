require "yaml"

module Cody
  class Role
    include Cody::Dsl::Role
    include Evaluate
    include Variables

    def initialize(options={})
      @options = options
      @role_path = options[:role_path] || get_role_path
      @properties = default_properties
      @iam_policy = {}
    end

    def run
      load_variables
      evaluate(@role_path) if File.exist?(@role_path)
      @properties[:policies] = [{
        policy_name: "CodeBuildAccess",
        policy_document: {
          version: "2012-10-17",
          statement: derived_iam_statements
        }
      }]

      if @managed_policy_arns && !@managed_policy_arns.empty?
        @properties[:managed_policy_arns] = @managed_policy_arns
      else
        @properties[:managed_policy_arns] = default_managed_policy_arns
      end

      resource = {
        IamRole: {
          type: "AWS::IAM::Role",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

  private
    def get_role_path
      lookup_cody_file("role.rb")
    end

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

    def default_managed_policy_arns
      # Useful when using with CodePipeline
      ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
    end
  end
end
