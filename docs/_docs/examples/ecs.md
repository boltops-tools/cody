---
title: ECS
nav_text: ECS
categories: example
nav_order: 16
---

This example will show some powerful patterns with the codebuild tool.  We'll use codebuild with the [ufo](https://ufoships.com) tool to deploy an application to ECS.

Here's the project DSL.

.codebuild/project.rb:


```ruby
github_url("https://github.com/tongueroo/demo-ufo)
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  UFO_ENV: Codebuild.env,
  UFO_APP: project_name,
)
```

Notice the use of `Codebuild.env` and `project_name` to set environment variables. The environment variables are later used in the `.buildspec.yml`.

* The `Codebuild.env` method contains the value of `CB_ENV` when you run the `cb deploy` command.
* The `project_name` is the CodeBuild project name itself.

If CodeBuild project name matches the ufo ECS service name, then it makes the commands very simple. For example.

    CB_ENV=production cb deploy demo-web

Creates a CodeBuild project that will deploy your app to production and create an ECS service named `demo-web` via ufo.

Here's the buildspec that references the environment variables set in `project.rb` earlier:

.codebuild/buildspec.yml

```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - gem install --no-document ufo
  build:
    commands:
      - echo Deploying project to ECS started on `date`
      - UFO_ENV=$UFO_ENV ufo ship $UFO_APP
```

Last, here's the IAM Policy that will give CodeBuild the IAM permissions necessary to create the ECS service and other resources that ufo can create:

.codebuild/role.rb:


```ruby
iam_policy(
  "cloudformation",
  "ec2",
  "ecr",
  "ecs",
  "elasticloadbalancing",
  "elasticloadbalancingv2",
  "logs",
  "route53",
  "ssm",
  {
      "Action": [
          "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {
          "StringLike": {
              "iam:PassedToService": [
                  "ecs-tasks.amazonaws.com"
              ]
          }
      }
  }
)
managed_iam_policy("AmazonS3ReadOnlyAccess") # optional but common to need read only access to s3
```

From a security perspective, using CodeBuild gives us a stronger security posture. The **only** permission the user calling [cb start]({% link _docs/start.md %}) really needs is CodeBuild access.  The permissions to create the ECS service and other deployment resources are delegated to the CodeBuild project itself. We know that the CodeBuild project will not run any arbitrary commands unless we update `buildspec.yml` and explicitly give permission to it's IAM role.

{% include examples-steps.md %}

## CodePipeline ECS Deploy Action

If you are using CodePipeline also, you may be wondering why not just use the provided Amazon ECS deployment action instead.  It comes down to control. With a CodeBuild project, we have full control of how we want to build and deploy the Docker image to ECS.

Also, with the CodePipeline ECS deploy action, we are unable to configure a timeout.  If the ECS deployment fails due to some reasons, we're stuck waiting 60 minutes for the pipeline timeout. There's a way to hack around this by literally overriding updating the CodeBuild project. You also must do it manually and are charged for the time. With CodeBuild project, you can set the timeout value yourself. Essentially, you have more control with CodeBuild.

{% include prev_next.md %}