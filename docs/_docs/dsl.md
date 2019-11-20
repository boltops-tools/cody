---
title: Cody DSL
---

Cody provides a simple yet powerful DSL to create CodeBuild related resources.  Here are some examples of resources it can create:

* [project]({% link _docs/dsl/project.md %}): The CodeBuild project. This is required.
* [iam role]({% link _docs/dsl/role.md %}): The IAM role associated with the CodeBuild project.
* [schedule]({% link _docs/dsl/schedule.md %}): An CloudWatch Event rule. The rule triggers the codebuild project to start on a scheduled basis.