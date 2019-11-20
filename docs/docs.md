---
title: Overview
---

## What is Cody?

Cody is an AWS CodeBuild Management Tool. Cody simplifies creating and managing [AWS CodeBuild](https://aws.amazon.com/codebuild/) projects. It provides a beautiful DSL to create a CodeBuild project.

The DSL is simply a wrapper to the [CloudFormation CodeBuild Project resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html). Essentially, this means you can **fullly control** and customize of the CodeBuild project.

## Usage Scenarios

Here are some ways to use CodeBuild:

* running unit tests
* deploying code
* building artifacts

Pretty much anything you want to automate, cody can run for you. Since CodeBuild is a fully managed service, it gives you the advantage of not having to manage the EC2 instance or the build software.  You do not have to worry about software patches, security updates, or software upgrades.