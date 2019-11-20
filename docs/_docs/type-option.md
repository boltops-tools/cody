---
title: Type Option
---

The `--type` option is a powerful option that allows you to create multiple codebuild projects associated with the same repo.

## Default Behavior

By default, cody looks up files in the `.cody` folder.  Example:

    .cody/buildspec.yml
    .cody/project.rb
    .cody/role.rb

You can affect the behavior of the lookup logic with the `--type` option.

## Examples

    cody deploy --type deploy

This will look up buildspec.yml, project.rb, and role.rb files in the `.cody/deploy` folder. So:

    .cody/deploy/buildspec.yml
    .cody/deploy/project.rb
    .cody/deploy/role.rb

Likewise `cody deploy --type unit` would result in:

    .cody/unit/buildspec.yml
    .cody/unit/project.rb
    .cody/unit/role.rb

## Structure

So if you need multiple CodeBuild projects that perform different tasks but are both related to the same code repo, this structure is useful:

    .cody
    ├── deploy
    │   ├── buildspec.yml
    │   ├── project.rb
    │   ├── role.rb
    │   └── schedule.rb
    └── unit
        ├── buildspec.yml
        ├── project.rb
        ├── role.rb
        └── schedule.rb

## Code Project Name

The CloudFormation stack name is appended with the name of the type option. So if your project folder is `demo` and the type option is `unit`.

    cd demo # project folder
    cody deploy --type unit

It produces a CodeBuild project named `demo-unit`.  The project name is an optional first CLI argument. Here's an example:

    cd demo # project folder
    cody deploy demo-web --type deploy # CodeProject name: demo-web-deploy

## Stack Name

The stack name is the same as the CodeBuild project name with the `-cody` suffix appended to it.  Examples:

CodeBuild Project Name | Stack Name
--- | ---
demo | demo-cody
demo-unit | demo-unit-cody
demo-web-unit | demo-web-unit-cody