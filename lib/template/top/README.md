# Cody Files

The files in folder are used by cody to build AWS CodeBuild projects.  For more info, check out the [cody docs](https://cody.run). Here's a quick start.

## Deploy CodeBuild Project

To deploy the CodeBuild project. IE: Ereate or update the CloudFormation stack.

Main services:

    cody deploy demo

If you have multiple codebuild projects associated with the same repo, you can use the `--type` option.  Example:

    cody deploy demo --type deploy

## Start a Deploy

To start a CodeBuild build:

    cody start demo
    cody start demo --type deploy

To specify a branch:

    cody start demo --type deploy -b feature
