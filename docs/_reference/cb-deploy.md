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

By default, cody looks up files in the `.codebuild` folder.  Example:

    .codebuild/buildspec.yml
    .codebuild/project.rb
    .codebuild/role.rb

### Examples

    cody deploy PROJECT_NAME --type deploy

This will look up buildspec.yml, project.rb, and role.rb files in the `.codebuild/deploy` folder. So:

    .codebuild/deploy/buildspec.yml
    .codebuild/deploy/project.rb
    .codebuild/deploy/role.rb

Likewise `cody deploy PROJECT_NAME --type unit` would result in:

    .codebuild/unit/buildspec.yml
    .codebuild/unit/project.rb
    .codebuild/unit/role.rb


## Options

```
[--type=TYPE]                # folder to use within .codebuild folder for different build types
[--stack-name=STACK_NAME]    # Override the generated stack name. If you use this you must always specify it
[--wait], [--no-wait]        # Wait for operation to complete
                             # Default: true
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
```

