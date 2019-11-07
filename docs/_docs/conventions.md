---
title: Naming Conventions
nav_order: 9
---

Cody follows a few naming conventions.

## Project Name

It will set the CodeBuild project name by inferring the name of the parent folder.  For example, if the parent folder is `demo`.

    cd demo
    cody deploy

The CodeBuild project is named `demo`. You can override this easily by providing a project name.

    cd deploy my-project # explicitly use my-project as CodeBuild project name

The CodeBuild project is named `my-project`

## Type Option

If the `--type` option is used, then it is appended to the CodeBuild project name. For example:

    cody deploy my-project --type unit

The CodeBuild project is named `my-project-unit`.

## CODY_ENV_EXTRA

The `CODY_ENV_EXTRA` also affects the name of the CodeBuild project.  It gets appended after the type option.

    CODY_ENV_EXTRA=2 cody deploy my-project --type unit

The CodeBuild project is named `my-project-unit-2`.

## Settings append_env option

If the `append_env: true` is configured in the [Settings]({% link _docs/settings.md %}), then the CODY_ENV gets injected into the CodeBuild **full** project name as well as the CloudFormation stack name.  The general form is `PROJECT_NAME-TYPE-CODY_ENV-CODY_ENV_EXTRA`. Example:

Cody Project Name | Type | CODY_ENV | CODY_ENV_EXTRA | Full AWS CodeBuild Project Name
--- | --- | --- | --- | ---
demo | deploy | development | 2 | demo-deploy-development-2

The default is `append_env: false`. So this is the usual full AWS CodeBuild project name:

Cody Project Name | Type | CODY_ENV | CODY_ENV_EXTRA | Full AWS CodeBuild Project Name
--- | --- | --- | --- | ---
demo | (not set) | development | (not set) | demo

## Stack Name

The CloudFormation stack name which creates the CodeBuild related resources is named the same as the project name with `-cody` appended to the stack name. Examples:

Cody Project Name | Stack Name
--- | ---
demo | demo-cody
demo-unit | demo-unit-cody
demo-web-unit | demo-web-unit-cody

Though not recommended, the `-cody` that gets appended to the stack can be adjusted with settings also.  For example, `stack_naming.append_stack_name: cb` would result in `demo-cb`.

{% include prev_next.md %}
