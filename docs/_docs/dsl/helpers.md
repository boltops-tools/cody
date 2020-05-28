---
title: Helpers
nav_text: Helpers
categories: dsl
nav_order: 14
---

Cody provides convenient helpers to define your CodeBuild related AWS resources. There are some common unique helpers that are cover here:

Helper | Description
--- | ---
project_name | The project name that is specified or conventionally inferred when you run the cody commands. IE: `cody deploy PROJECT_NAME`, `cody start PROJECT_NAME`, etc. So `cody start demo` means the project name is `demo`.
full\_project\_name | The full project name includes the project_name, type, env, and extra options. IE: `cody deploy demo --type deploy` means full project name is `demo-deploy-development`. This is covered also in the [Cody Conventions Docs]({% link _docs/conventions.md %}).

For other helper methods, refer to each DSL resource for more docs and the source code. In general, the helper methods are simply wrapper methods to for the corresponding CloudFormation resource properties.

{% include prev_next.md %}
