---
title: Deploy
nav_order: 6
---

The CodeBuild project is generated from the DSL and created with CloudFormation. By default, the files that the DSL evaluates are:

    .cody/buildspec.yml
    .cody/project.rb
    .cody/role.rb

To create the CodeBuild project, you run:

    cody deploy

You'll see output that looks something like this:

    $ cody deploy
    Generated CloudFormation template at /tmp/codebuild.yml
    Deploying stack demo-cody with CodeBuild project demo
    Creating stack demo-cody. Check CloudFormation console for status.
    Stack name demo-cody status CREATE_IN_PROGRESS
    Here's the CloudFormation url to check for more details https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks
    Waiting for stack to complete
    03:04:30AM CREATE_IN_PROGRESS AWS::CloudFormation::Stack demo-cody User Initiated
    03:04:34AM CREATE_IN_PROGRESS AWS::IAM::Role IamRole
    03:04:35AM CREATE_IN_PROGRESS AWS::IAM::Role IamRole Resource creation Initiated
    03:04:54AM CREATE_COMPLETE AWS::IAM::Role IamRole
    03:04:56AM CREATE_IN_PROGRESS AWS::CodeBuild::Project CodeBuild
    03:04:58AM CREATE_IN_PROGRESS AWS::CodeBuild::Project CodeBuild Resource creation Initiated
    03:04:59AM CREATE_COMPLETE AWS::CodeBuild::Project CodeBuild
    03:05:01AM CREATE_COMPLETE AWS::CloudFormation::Stack demo-cody
    Stack success status: CREATE_COMPLETE
    Time took for stack deployment: 30s.
    $

## Explicit CodeBuild Project Name

By default, the CodeBuild project name is inferred and is the parent folder that you are within.  You can explicitly specify the project name as the first CLI argument:

    cody deploy my-project

## Types

By default, cody looks up files in the `.cody` folder.  Example:

    .cody/buildspec.yml
    .cody/project.rb
    .cody/role.rb

You can use the `--type` option to tell the tool to lookup files in a subfolder.  Here's an example.

    cody deploy PROJECT_NAME --type deploy

This will look up `buildspec.yml`, `project.rb`, and `role.rb` files in the `.cody/deploy` folder. So:

    .cody/deploy/buildspec.yml
    .cody/deploy/project.rb
    .cody/deploy/role.rb

Likewise `cody deploy PROJECT_NAME --type unit` would result in:

    .cody/unit/buildspec.yml
    .cody/unit/project.rb
    .cody/unit/role.rb

Also, for help info you can check the [cody deploy]({% link _reference/cody-deploy.md %}) CLI reference.

{% include prev_next.md %}
