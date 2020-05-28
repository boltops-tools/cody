---
title: AWS CodeBuild Docker Images
nav_order: 12
---

AWS has evolved the way they manage their official curated images over the years. Here are some useful notes. It's more focused on Linux images.

## Timeline

* 2018 Strategy was to build separate Docker images for different runtimes like Java, Python, Go, Ruby, PHP, Node, etc
* 2019 AWS shifted its strategy to build one baseline image. We specify the desired runtimes to be installed. Docs here: [Runtime versions in buildspec file sample for CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-runtime-versions.html)

The interesting thing about this shift is that it makes it easier to install multiple runtimes if needed.  For example, you might need the Ruby runtime but also need the NodeJS runtime for asset compilation.

## List Images

Here's a useful command to list the images:

    aws codebuild list-curated-environment-images | jq '.platforms[].languages[].images[].name'

## Standard Images

There are 2 different types of standard images. Here are examples of each type:

1. [aws/codebuild/standard:4.0](https://github.com/aws/aws-codebuild-docker-images/tree/master/ubuntu/standard/4.0): Based on Ubuntu.
2. [amazonlinux2-x86_64-standard:3.0](https://github.com/aws/aws-codebuild-docker-images/tree/master/al2/x86_64/standard/3.0): Based on AmazonLinux2.

## Ruby Versions

As of this writing, it looks like Ubuntu images have more recent versions of Ruby. For example, Ubuntu has Ruby 2.7 and AmazonLinux has Ruby 2.6.

## Links

* [Docker images provided by CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html)
* [AWS CodeBuild Docker Images](https://github.com/aws/aws-codebuild-docker-images)

{% include prev_next.md %}
