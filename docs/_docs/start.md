---
title: Start
nav_order: 7
---

You can start a CodeBuild project with the `cb start` command. Here's an example:

    $ cb start
    Build started for project: demo
    Please check the CodeBuild console for the status.
    Codebuild Log Url:
    https://us-west-2.console.aws.amazon.com/codesuite/codebuild/projects/demo/build/demo%3A7bc4cb33-d918-467a-9e09-fe7fe1f57ed8/log
    $

## Specifying Code Branch

If you would like start a build using a specific code branch you can use the `--branch` or `-b` option.  Example:

    cb start -b feature-branch

## AWS CLI Equivalent

The `cb start` command is a simple wrapper to the AWS API with the ruby sdk. You can also start codebuild projects with the `aws codebuild` cli.  Here's the equivalent CLI command:

    aws codebuild start-build --project-name demo --source-version master

## Types

If you are using multiple Codebuild projects with [Types]({% link _docs/type-option.md %}), you can start the specific CodeBuild project type with the `--type` option.  Example:

    cb start --type unit

## Override CodeBuild Environment Variables

You can override CodeBuild env variables at runtime with `--env-vars`. Examples:

    cb start --type vpc --env-vars K1=v1 K2=v2
    cb start --type vpc --env-vars K1=v1 K2=ssm:v2 # support for PARAMETER_STORE

Remember the environment variables are within the CodeBuild environment instance running the build script, not the application's environment.

## CLI Reference

Also, for help info you can check the [cb start]({% link _reference/cb-start.md %}) CLI reference.

{% include prev_next.md %}