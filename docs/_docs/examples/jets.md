---
title: Jets
nav_text: Jets
categories: example
nav_order: 20
---

This example shows to deploy a [Jets](https://rubyonjets.com/) application with codebuild to AWS Lambda.

Here's the project DSL.

.cody/project.rb:


```ruby
github_url("https://github.com/tongueroo/jets-cody-demo")
linux_image("aws/codebuild/amazonlinux2-x86_64-standard:3.0")
environment_variables(
  JETS_ENV: Cody.env,
  JETS_TOKEN: ssm("/jets-cody-demo/#{Cody.env}/CODY_JETS_TOKEN"),
)
```

The [.cody/project.rb](https://github.com/tongueroo/jets-cody-demo/blob/master/.cody/project.rb) uses a Docker image that has Ruby, Node, and Yarn already installed.  If you prefer to use another image, update the `linux_image` setting, and update your `buildspec.yml` accordingly. For example, you may need to install the necessary packages.

Here's the buildspec:

.cody/buildspec.yml

```yaml
# Build Specification Reference for CodeBuild: https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html

version: 0.2

phases:
  install:
    commands:
      - yum install -y rsync zip
      - curl -s -o- -L https://yarnpkg.com/install.sh | bash
    runtime-versions:
      nodejs: latest
      ruby: 2.7
  build:
    commands:
      - bash -c 'if [ "$CODEBUILD_BUILD_SUCCEEDING" == "0" ]; then exit 1; fi'
      - ruby --version
      - yarn install --check-files
      - bundle
      - export JETS_AGREE=yes
      - bundle exec jets configure $JETS_TOKEN
      - bundle exec jets deploy $JETS_ENV
```

And here are the IAM permissions required as described in [Jets Minimal IAM Deploy Policy](https://rubyonjets.com/docs/extras/minimal-deploy-iam/).

.cody/role.rb:

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

Here's also Github repo with CodeBuild examples with Jets: [tongueroo/jets-cody-demo](https://github.com/tongueroo/jets-cody-demo).  The example on the master branch is a similar simple approach with 1 CodeBuild project.

You may be interested in the [separate-unit-and-deploy branch](https://github.com/tongueroo/jets-cody-demo/tree/separate-unit-and-deploy). The example shows how to set up 2 separate CodeBuild projects. Some advantages:

* The projects are decoupled and you can run them separately.
* Only the deploy project requires IAM access to create the AWS resources.

{% include examples-steps.md %}

{% include prev_next.md %}
