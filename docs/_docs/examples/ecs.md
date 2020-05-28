---
title: ECS
nav_text: ECS
categories: example
nav_order: 19
---

This example will show some powerful patterns with cody.  We'll use cody with the [ufo](https://ufoships.com) tool to deploy an application to ECS.

Here's the project DSL.

.cody/project.rb:


```ruby
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/standard:4.0")
environment_variables(
  UFO_ENV: Cody.env,
  UFO_APP: project_name,
)
```

Notice the use of `Cody.env` and `project_name` to set environment variables. The environment variables are later used in the `.buildspec.yml`.

* The `Cody.env` method contains the value of `CODY_ENV` when you run the `cody deploy` command.
* The `project_name` is the CodeBuild project name itself.  It does not include the `--type` option.

If CodeBuild project name matches the ufo ECS service name, then it makes the commands very simple. For example.

    CODY_ENV=production cody deploy demo-web

Creates a CodeBuild project that will deploy your app to production and create an ECS service named `demo-web` via ufo.

Here's the buildspec that references the environment variables set in `project.rb` earlier:

.cody/buildspec.yml

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      ruby: latest
  pre_build:
    commands:
      - gem install --no-document ufo
  build:
    commands:
      - echo Deploying project to ECS started on `date`
      - UFO_ENV=$UFO_ENV ufo ship $UFO_APP
```

The `ufo ship` command:

    UFO_ENV=$UFO_ENV ufo ship $UFO_APP

When codebuild actually runs, the values will be:

    UFO_ENV=production ufo ship demo-web

## IAM Policy

Cody also can create the IAM Policy that will give CodeBuild the IAM permissions necessary to create the ECS service and other resources that `ufo ship` creates. Here are the IAM permissions as detailed on the [UFO Minimal IAM Permissions](https://ufoships.com/docs/extras/minimal-deploy-iam/) docs.

.cody/role.rb:

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

## Security

From a security perspective, using CodeBuild gives us a stronger security posture. The **only** permission the user calling [cody start]({% link _docs/start.md %}) really needs is CodeBuild access.  The permissions to create the ECS service and other deployment resources are delegated to the CodeBuild project itself. We know that the CodeBuild project will not run any arbitrary commands unless we update `buildspec.yml` and explicitly give permission to it's IAM role.

## Create CodeBuild Project

To create the CodeBuild project via CloudFormation run:

    cody deploy demo-web

This creates the CodeBuild project as well as the necessary IAM role.

## Start Build

To start a build:

    cody start demo-web

You can also start a build with a specific branch. Remember to `git push` your branch.

    cody start demo-web -b mybranch

## CodePipeline ECS Deploy Action

If you are using CodePipeline also, you may be wondering why not just use the provided Amazon ECS deployment action instead.  It comes down to control. With a CodeBuild project, we have full control of how we want to build and deploy the Docker image to ECS.

Also, with the CodePipeline ECS deploy action, we are unable to configure a timeout.  If the ECS deployment fails due to some reasons, we're stuck waiting 60 minutes for the pipeline timeout. There's a way to hack around this by literally overriding updating the CodeBuild project. You also must do it manually and are charged for the time if you don't notice it. With CodeBuild project, you can set the timeout value yourself. Essentially, you have more control with CodeBuild. There's some more info here: [CodePipeline ECS Deploy vs CodeBuild ufo ship](https://codepipeline.org/docs/ecs-deploy/).

{% include prev_next.md %}
