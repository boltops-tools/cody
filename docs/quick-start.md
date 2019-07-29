---
title: Quick Start
nav_order: 1
---

In a hurry? No problem!  Here's a quick start to get going.

## Summary

    gem install codebuild
    cd <your-project>
    cb init # generates starter .codebuild files
    # edit .codebuild/buildspec.yml
    cb deploy # create the CodeBuild project via CloudFormation
    cb start  # start a CodeBuild project. Runs the buildspec.yml

## What Happened?

Here are a little more details on what the summarized commands do. First, we install the codebuild tool.

    gem install codebuild

Change into your project directory.

    cd <your-project>

If you need a demo project, you can try this demo project: [tongueroo/demo-ufo](git clone https://github.com/tongueroo/demo-ufo).

    git clone https://github.com/tongueroo/demo-ufo demo
    cd demo

Create the starter .codebuild files in the project.

    cb init # generates starter .codebuild files

An important generated file `.codebuild/buildspec.yml`. The starter file looks something like this:

```yaml
phases:
  build:
    commands:
      - echo Build started on `date`
      - uptime
```

All it does is run a `uptime` command as part of the CodeProject build. Edit it for your needs. Remember to commit it and push it to the repo.

The CodeBuild project is defined in `.codebuild/project.rb` via the [Project DSL]({% link _docs/dsl/project.md %}). It looks something like this:

```ruby
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  JETS_ENV: "test"
)
```

To define a project, it is literally 3 lines of code. You can deploy it with a single command:

    cb deploy

This deploys a CloudFormation stack that creates a CodeBuild project and IAM role.  The IAM role permissions is defined in `.codebuild/role.rb` via the [IAM Role DSL]({% link _docs/dsl/role.md %}).

Once the stack is complete. You can start the CodeBuild project via the CLI or the CodeBuild console.  Here is the CLI command:

    cb start

Here's what CodeBuild project output looks like:

![](/img/docs/codebuild-output.png)

{% include prev_next.md %}