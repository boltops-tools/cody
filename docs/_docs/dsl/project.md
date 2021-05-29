---
title: Project DSL
nav_text: Project
categories: dsl
nav_order: 15
---

You define the CodeBuild project in `.cody/project.rb`. Here's an example of the DSL used to create a codebuild project.

.cody/project.rb:

```ruby
# name("demo") # recommended to leave unset and use the conventional name that cody sets
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/standard:4.0")
environment_variables(
  UFO_ENV: "development",
  API_KEY: "ssm:/codebuild/demo/api_key" # ssm param example
)
```

Here's a list of some of the convenience shorthand DSL methods:

* buildspec(path)
* environment_variables(vars)
* github_source(options={})
* github_url(url)
* linux_environment(options={})
* linux_image(name)
* local_cache(enable=true)

Refer to the [dsl/project.rb](https://github.com/tongueroo/cody/blob/master/lib/cody/dsl/project.rb) source code for the most updated list of methods.

## Webhook Example

If you would like for a build to run on every commit pushed.

```ruby
triggers(Webhook: true)
```

For more control over the branches to run:

```ruby
triggers(
  Webhook: true,
  FilterGroups: [[{Type: "HEAD_REF", Pattern: "my-branch"}, {Type: "EVENT", Pattern: "PUSH"}]]
)
```

Notes:

* The extra brackets: `[[]]` is actually the proper format. I know weird.
* The GitHub oauth token needs admin:repo_hook permissions for triggers.

## Full DSL

The convenience methods are shorter and cleaner. However, you have access to a Full DSL if needed. The Full DSL methods are merely the properties of the [AWS::CodeBuild::Project CloudFormation Resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html).  Here's an example.

.cody/project.rb:

```ruby
# name("demo") # recommend to not set, and let cody set this automatically
description("desc2")
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-source.html
source(
  Type: "GITHUB",
  Location: "https://github.com/tongueroo/demo-ufo",
  GitCloneDepth: 1,
  GitSubmodulesConfig: { FetchSubmodules: true },
  BuildSpec: ".cody/buildspec.yml",
  Auth: {
    Type: "OAUTH",
    Resource: ssm("/codebuild/demo/oauth_token"),
  },
  ReportBuildStatus: true,
)

artifacts(Type: "NO_ARTIFACTS")
environment(
  ComputeType: "BUILD_GENERAL1_SMALL",
  ImagePullCredentialsType: "CODEBUILD",
  PrivilegedMode: true,
  Image: "aws/codebuild/standard:4.0",
  EnvironmentVariables: [
    {
      Type: "PLAINTEXT",
      Name: "UFO_ENV",
      Value: "development"
    },
    {
      Type: "PARAMETER_STORE",
      Name: "API_KEY",
      Value: "/codebuild/demo/api_key"
    }
  ],
  Type: "LINUX_CONTAINER"
)

service_role(ref: "IamRole")
```

{% include prev_next.md %}
