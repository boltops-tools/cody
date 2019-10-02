---
title: Settings
nav_order: 8
---

The `.cody/settings.yml` file can be used to adjust some of the behavior of cody.  Here's an example of a settings.yml file:

```yaml
base:
  # stack_naming:
  #   append_env: true # default false

development:
  # aws_profile: dev_profile

production:
  # aws_profile: prod_profile
```

The base settings are common and used for all the environments. The other environments are used according to the value of `CODY_ENV`.

## Example

    cody deploy # will use the development settings since development is the default
    CODY_ENV=production cody deploy # will use the production settings

## Options

Name | Description
--- | ---
stack_naming.append_env | Determines if `CODY_ENV` value is append to the CodeBuild project name.
aws_profile | This provides a way to bind `CODY_ENV` to `AWS_PROFILE` tightly. This prevents you from forgetting to switch your `CODY_ENV` when switching your `AWS_PROFILE`, thereby accidentally launching a stack in the wrong environment.

{% include prev_next.md %}