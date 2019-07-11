---
title: codebuild start
reference: true
---

## Usage

    codebuild start

## Description

start codebuild project.

# Examples

    cb start # infers the name from the parent folder
    cb start stack-name # looks up project via CloudFormation stack
    cb start demo-project # looks up project via codebuild project name

## Overriding Env Variables at Runtime

You can override env variables at runtime with `--env-vars`. Examples:

    cb start --type vpc --env-vars K1=v1 K2=v2
    cb start --type vpc --env-vars K1=v1 K2=ssm:v2 # support for PARAMETER_STORE


## Options

```
    [--source-version=SOURCE_VERSION]  # git branch
                                       # Default: master
b, [--branch=BRANCH]                   # git branch
                                       # Default: master
    [--env-vars=one two three]         # env var overrides. IE: KEY1=VALUE1 KEY2=VALUE2
    [--type=TYPE]                      # folder to use within .codebuild folder for different build types
    [--stack-name=STACK_NAME]          # Override the generated stack name. If you use this you must always specify it
    [--wait], [--no-wait]              # Wait for operation to complete
                                       # Default: true
    [--verbose], [--no-verbose]        
    [--noop], [--no-noop]              
```

