---
title: Quick Start
nav_order: 1
---

In a hurry? No problem!  Here's a quick start to get going.

## Summary

    gem install cody
    cd <your-project>
    cody init # generates starter .cody files
    # edit .cody/buildspec.yml
    # git commit and push your changes. codebuild will git pull them down.
    cody deploy # create the CodeBuild project via CloudFormation
    cody start  # start a CodeBuild project. Runs the buildspec.yml

## What Happened?

Here are a little more details on what the summarized commands do. First, we install cody tool.

    gem install cody

Change into your project directory.

    cd <your-project>

If you do not have a project, simply create an empty folder.

    mkdir demo
    cd demo

Create the starter .cody files in the project.

    cody init # generates starter .cody files

An important generated file `.cody/buildspec.yml`. The starter file looks something like this:

```yaml
phases:
  build:
    commands:
      - echo Build started on `date`
      - uptime
```

All it does is run a `uptime` command as part of the CodeProject build. Edit it for your needs. Remember to commit it and push it to the repo.

The CodeBuild project is defined in `.cody/project.rb` via the [Project DSL]({% link _docs/dsl/project.md %}). It looks something like this:

```ruby
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  JETS_ENV: "test"
)
```

To define a project, it's only 3 lines of code.

Make sure youpushed to github, since codebuild will be pulling from it.

    git remote add origin git@github.com/user/repo # update with your own repo
    git add .
    git commit -m 'test commit'
    git push

### Deploy

Now we're ready to deploy. You can deploy it with a single command:

    cody deploy

This deploys a CloudFormation stack that creates a CodeBuild project and IAM role.  The IAM role permissions is defined in `.cody/role.rb` via the [IAM Role DSL]({% link _docs/dsl/role.md %}).

Once the stack is complete. You can start the CodeBuild project via the CLI or the CodeBuild console.  Here is the CLI command:

    cody start

Here's what CodeBuild project output looks like:

![](/img/docs/codebuild-output.png)

{% include prev_next.md %}