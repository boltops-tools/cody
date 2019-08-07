---
title: Jets
nav_text: Jets
categories: example
nav_order: 17
---

This example shows to deploy a [Jets](https://rubyonjets.com/) application with codebuild to AWS Lambda.

Here's the project DSL.

.codebuild/project.rb:


```ruby
github_url("https://github.com/tongueroo/jets-codebuild")
linux_image("timbru31/ruby-node:2.5") # currently must used ruby 2.5 for Lambda
environment_variables(
  JETS_ENV: Codebuild.env,
)
```

The [.codebuild/project.rb](https://github.com/tongueroo/jets-codebuild/blob/master/.codebuild/project.rb) uses a Docker image that has Ruby, Node, and Yarn already installed.  If you prefer to use another image, update the `linux_image` setting, and update your `buildspec.yml` accordingly. For example, you may need to install the necessary packages.

Here's the buildspec:

.codebuild/buildspec.yml

```yaml
version: 0.2

phases:
  install:
    commands:
      - apt-get update -y
      - apt-get install -y rsync zip
  build:
    commands:
      - echo Build started on `date`
      - sed -i '/BUNDLED WITH/Q' Gemfile.lock # hack to fix bundler issue: allow different versions of bundler to work
      - bundle
      - JETS_ENV=test bundle exec rspec
  post_build:
    commands:
      - bash -c 'if [ "$CODEBUILD_BUILD_SUCCEEDING" == "0" ]; then exit 1; fi'
      - export JETS_AGREE=yes
      - bundle exec jets deploy $JETS_ENV

```

And here are the IAM permissions required as described in [Jets Minimal IAM Deploy Policy](https://rubyonjets.com/docs/extras/minimal-deploy-iam/).

.codebuild/role.rb:

```ruby
iam_policy(
  "apigateway",
  "cloudformation",
  "dynamodb",
  "events",
  "iam",
  "lambda",
  "logs",
  "route53",
  "s3",
  "ssm",
)
```

Here's also Github repo with CodeBuild examples with Jets: [tongueroo/jets-codebuild](https://github.com/tongueroo/jets-codebuild).  The example on the master branch is a similar simple approach with 1 CodeBuild project.

You may be interested in the [separate-unit-and-deploy branch](https://github.com/tongueroo/jets-codebuild/tree/separate-unit-and-deploy). The example shows how to set up 2 separate CodeBuild projects. Some advantages:

* The projects are decoupled and you can run them separately.
* Only the deploy project requires IAM access to create the AWS resources.

{% include examples-steps.md %}

{% include prev_next.md %}
