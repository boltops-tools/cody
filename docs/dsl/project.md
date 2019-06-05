# Project DSL

The convenience methods are shorter and cleaner. However, you have access to a "Full" DSL if needed. The Full DSL are merely the properties of the [AWS::CodeBuild::Project CloudFormation Resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html).  Here's an example.

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
