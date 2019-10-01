---
title: Settings
nav_order: 8
---

The `.codebuild/settings.yml` file can be used to adjust some of the behavior of the codebuild tool.  Here's an example of a settings.yml file:

```yaml
base:
  # stack_naming:
  #   append_env: true # default false

development:
  # aws_profile: dev_profile

production:
  # aws_profile: prod_profile
```

The base settings are common and used for all the environments. The other environments are used according to the value of `CB_ENV`.

## Example

    cody deploy # will use the development settings since development is the default
    CB_ENV=production cody deploy # will use the production settings

## Options

Name | Description
--- | ---
stack_naming.append_env | Determines if `CB_ENV` value is append to the CodeBuild project name.
aws_profile | This provides a way to bind CB_ENV to AWS_PROFILE tightly. This prevents you from forgetting to switch your CB_ENV when switching your AWS_PROFILE, thereby accidentally launching a stack in the wrong environment.

{% include prev_next.md %}