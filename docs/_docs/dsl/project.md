---
title: Project DSL
nav_text: Project
categories: dsl
nav_order: 12
---

You define the CodeBuild project in `.codebuild/project.rb`. Here's an example of the DSL used to create a codebuild project.

.codebuild/project.rb:

```ruby
# name("demo") # recommended to leave unset and use the conventional name that cb tool sets
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  UFO_ENV: "development",
  API_KEY: "ssm:/codebuild/demo/api_key" # ssm param example
)
```

Here's a list of some of the convenience shorthand DSL methods:

* github_url(url)
* github_source(options={})
* linux_image(name)
* linux_environment(options={})
* environment_variables(vars)
* local_cache(enable=true)

Refer to the [dsl/project.rb](https://github.com/tongueroo/codebuild/blob/master/lib/codebuild/dsl/project.rb) source code for the most updated list of methods.

## Full DSL

The convenience methods are shorter and cleaner. However, you have access to a Full DSL if needed. The Full DSL methods are merely the properties of the [AWS::CodeBuild::Project CloudFormation Resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html).  Here's an example.

.codebuild/project.rb:

```ruby
name("demo") # recommend to not set this, and let the codebuild tool set this automatically
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

{% include prev_next.md %}