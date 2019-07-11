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
github_url("https://github.com/tongueroo/jets-hello-examples")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0") # currently must used ruby 2.5
environment_variables(
  JETS_ENV: Codebuild.env,
)
```

Here's the buildspec:

.codebuild/buildspec.yml

```yaml
version: 0.2

phases:
  install:
    commands:
      - apt-get update -y && apt-get install -y rsync # prequisite for jets
  build:
    commands:
      - echo Build started on `date`
      - sed -i '/BUNDLED WITH/Q' Gemfile.lock # hack to fix bundler issue: allow different versions of bundler to work
      - gem install bundler:1.16.6
      - export JETS_ENV=test
      - bundle
      - bundle exec rspec
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

{% include prev_next.md %}