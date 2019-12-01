---
title: cody deploy
reference: true
---

## Usage

    cody deploy

## Description

Deploy codebuild project.

## Examples

    cody deploy PROJECT_NAME # explicitly specify project-name
    cody deploy # infers the CodeBuild name from the parent folder

It is useful to just see the generated CloudFormation template with `--noop` mode:

    cody deploy PROJECT_NAME --noop # see generated CloudFormation template

## Types

By default, cody looks up files in the `.cody` folder.  Example:

    .cody/buildspec.yml
    .cody/project.rb
    .cody/role.rb

### Examples

    cody deploy PROJECT_NAME --type deploy

This will look up buildspec.yml, project.rb, and role.rb files in the `.cody/deploy` folder. So:

    .cody/deploy/buildspec.yml
    .cody/deploy/project.rb
    .cody/deploy/role.rb

Likewise `cody deploy PROJECT_NAME --type unit` would result in:

    .cody/unit/buildspec.yml
    .cody/unit/project.rb
    .cody/unit/role.rb


## Options

```
t, [--type=TYPE]                 # folder to use within .cody folder for different build types
    [--stack-name=STACK_NAME]    # Override the generated stack name. If you use this you must always specify it
    [--wait], [--no-wait]        # Wait for operation to complete
                                 # Default: true
    [--verbose], [--no-verbose]  
    [--noop], [--no-noop]        
```

