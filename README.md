# Codebuild

CodeBuild tool.

## Usage

    codebuild init
    codebuild deploy
    codebuild start

## Convenience DSL

The tool provides a DSL to create a codebuild project.  Here's an example of the DSL using the wrapper convenience methods.

.codebuild/project.rb:

```ruby
name("demo")
github_source(
  location: "https://github.com/tongueroo/demo-ufo",
  oauth_token: ssm("/codebuild/demo/oauth_token"),
)
linux_environment(image: "aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  UFO_ENV: "development",
  API_KEY: "ssm:/codebuild/demo/api_key"
)
```

The convenience methods are defined in the [lib/codebuild/dsl/project.rb](lib/codebuild/dsl/project.rb) class.

## "Full" DSL

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

## Convenience IAM Role DSL

The codebuild tool can create the IAM service role associated with the codebuild project. This is also a DSL. Here's an example:

.codebuild/role.rb:

```ruby
iam_statement(
  action: [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ],
  effect: "Allow",
  resource: "*"
)
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

## Installation

Add this line to your application's Gemfile:

    gem "codebuild"

And then execute:

    bundle

Or install it yourself as:

    gem install codebuild

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
