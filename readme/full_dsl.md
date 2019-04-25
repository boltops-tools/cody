# "Full" DSL

## Project DSL

The convenience is shorter and cleaner, however you have access to a "Full" DSL if needed. The convenience methods merely wrap properties of the [AWS::CodeBuild::Project CloudFormation Resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html).  If you wanted to set the CloudFormation properties more directly, here's an example of using the "Full" DSL.

.codebuild/project.rb:

```ruby
name("demo")
description("desc2")
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-source.html
source(
  type: "GITHUB",
  location: "https://github.com/tongueroo/demo-ufo",
  git_clone_depth: 1,
  git_submodules_config: { fetch_submodules: true },
  build_spec: ".codebuild/buildspec.yml",
  auth: {
    type: "OAUTH",
    resource: ssm("/codebuild/demo/oauth_token"),
  },
  report_build_status: true,
)

artifacts(type: "NO_ARTIFACTS")
environment(
  compute_type: "BUILD_GENERAL1_SMALL",
  image_pull_credentials_type: "CODEBUILD",
  privileged_mode: true,
  image: "aws/codebuild/ruby:2.5.3-1.7.0",
  environment_variables: [
    {
      type: "PLAINTEXT",
      name: "UFO_ENV",
      value: "development"
    },
    {
      type: "PARAMETER_STORE",
      name: "API_KEY",
      value: "/codebuild/demo/api_key"
    }
  ],
  type: "LINUX_CONTAINER"
)

service_role(ref: "IamRole")
```

## Full IAM Role DSL

The convenience methods merely wrap properties of the [AWS::IAM::Role
 CloudFormation Resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html).  If you wanted to set the CloudFormation properties more directly, here's an example of using the "Full" DSL.

.codebuild/role.rb:

```ruby
assume_role_policy_document(
  statement: [{
    action: ["sts:AssumeRole"],
    effect: "Allow",
    principal: {
      service: ["codebuild.amazonaws.com"]
    }
  }],
  version: "2012-10-17"
)
path("/")
policies([{
  policy_name: "CodeBuildAccess",
  policy_document: {
    version: "2012-10-17",
    statement: [{
      action: [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ],
      effect: "Allow",
      resource: "*"
    }]
  }
}])
```
