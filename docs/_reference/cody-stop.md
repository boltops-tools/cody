---
title: cody stop
reference: true
---

## Usage

    cody stop

## Description

stop codebuild project.

# Examples

    cody stop # infers the name from the parent folder
    cody stop stack-name # looks up project via CloudFormation stack
    cody stop demo-project # looks up project via codebuild project name

## Type Option

Examples

    cody stop --type vpc


## Options

```
[--build-id=BUILD_ID]        # Project build id. Defaults to most recent.
[--type=TYPE]                # folder to use within .cody folder for different build types
[--stack-name=STACK_NAME]    # Override the generated stack name. If you use this you must always specify it
[--wait], [--no-wait]        # Wait for operation to complete
                             # Default: true
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
```

