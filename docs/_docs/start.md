---
title: Start
nav_order: 5
---

You can start a CodeBuild project with the `cody start` command. Here's an example:

    $ cody start demo
    Build started for project: demo
    Here's the CodeBuild Console Log url:
    https://us-west-2.console.aws.amazon.com/codesuite/codebuild/projects/demo/build/demo%3A7bc4cb33-d918-467a-9e09-fe7fe1f57ed8/log
    Showing logs for build demo:10b8c4dc-e328-4759-9e32-805bcee8d1f9
    Phase: SUBMITTED Status: SUCCEEDED Duration: 0
    Phase: QUEUED Status:  Duration:
    Phase: QUEUED Status: SUCCEEDED Duration: 1
    ...
    Phase: FINALIZING Status: SUCCEEDED Duration: 2
    Phase: COMPLETED Status:  Duration:
    2019-11-28 05:29:23 UTC 9: post_build
    2019-11-28 05:29:23 UTC Thu Nov 28 05:29:21 UTC 2019
    2019-11-28 05:29:25 UTC
    2019-11-28 05:29:25 UTC [Container] 2019/11/28 05:29:23 Phase complete: POST_BUILD State: SUCCEEDED
    2019-11-28 05:29:25 UTC [Container] 2019/11/28 05:29:23 Phase context status code:  Message:
    $

If the project name is the same as the parent folder name then you can do this:

    cd demo
    cody start # demo is inferred from the parent folder

## Specifying Code Branch

If you would like start a build using a specific code branch you can use the `--branch` or `-b` option.  Example:

    cody start demo -b feature-branch

## AWS CLI Equivalent

The `cody start` command is a simple wrapper to the AWS API with the ruby sdk. You can also start codebuild projects with the `aws codebuild` cli.  Here's the equivalent CLI command:

    aws codebuild start-build --project-name demo --source-version master

## Types

If you are using multiple Cody projects with [Types]({% link _docs/type-option.md %}), you can start the specific CodeBuild project type with the `--type` option.  Example:

    cody start demo --type unit

## Override CodeBuild Environment Variables

You can override CodeBuild env variables at runtime with `--env-vars`. Examples:

    cody start demo --type vpc --env-vars K1=v1 K2=v2
    cody start demo --type vpc --env-vars K1=v1 K2=ssm:v2 # support for PARAMETER_STORE

Remember the environment variables are within the CodeBuild environment instance running the build script, not the application's environment.

## CLI Reference

Also, for help info you can check the [cody start]({% link _reference/cody-start.md %}) CLI reference.

{% include prev_next.md %}
