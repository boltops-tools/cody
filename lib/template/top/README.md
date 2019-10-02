# Cody Files

The files in folder are used by cody to build AWS CodeBuild projects.  For more info, check out the [cody docs](https://cody.run). Here's a quick start.

## Install Tool

    gem install cody

This installs the `cody` command to manage the AWS CodeBuild project.

## Update Project

To update the CodeBuild project:

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
