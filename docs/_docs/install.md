---
title: Installation
---

## RubyGems

Install codebuild via RubyGems.

    gem install cody

The [Quick Start]({% link quick-start.md %}) provides a guide on how to use cody.  The [DSL Docs]({% link _docs/dsl.md %}) provide more detail on the syntax.

## AWS CLI

AWS access is required.  Though you can set up acess with `AWS_*` environment variables, the AWS CLI is strongly recommended. It'll allow the use of AWS Profiles. You can install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) via pip.

    pip install awscli --upgrade --user

Then [configure it](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

    aws configure
