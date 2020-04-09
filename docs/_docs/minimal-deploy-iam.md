---
title: Minimal Deploy IAM Policy
nav_order: 11
---

The IAM user you use to run the `cody deploy` command needs a minimal set of IAM policies in order to deploy a CodeBuild project. Here is a table of the baseline services needed:

Service | Description
--- | ---
CloudFormation | To create the CloudFormation stacks that then creates AWS resources that cody creates.
CodeBuild | To create the CodeBuid project.
Events | To create the CloudWatch Event Rules to start CodeBuild projects periodically. You can define schedule with the [Schedule DSL]({% link _docs/dsl/schedule.md %})
IAM | To create IAM role to be associated with the CodeBuild project functions. This gives your code permission to access AWS resources. You can define those permissions with the [Role DSL]({% link _docs/dsl/role.md %})
Logs | To write to CloudWatch logs.
SSM | Required if you're using the `ssm` helper method to store secrets.

## Instructions

It is recommended that you create an IAM group and associate it with the IAM users that need access to use `cody deploy`.  Here are starter instructions and a policy that you can tailor for your needs:

### Commands Summary

Here's a summary of the commands:

    aws iam create-group --group-name Cody
    cat << 'EOF' > /tmp/cody-iam-policy.json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                  "cloudformation:*",
                  "codebuild:*",
                  "events:*",
                  "iam:*",
                  "logs:*",
                  "ssm:*",
                 ],
                "Resource": [
                    "*"
                ]
            }
        ]
    }
    EOF
    aws iam put-group-policy --group-name Jets --policy-name JetsPolicy --policy-document file:///tmp/cody-iam-policy.json

Then create a user and add the user to IAM group. Here's an example:

    aws iam create-user --user-name tung
    aws iam add-user-to-group --user-name tung --group-name Cody

## Cody Deploy IAM Policy vs the CodeBuild IAM Policy

This page refers to your **user** IAM policy used when running `cody deploy`. These are different from the IAM Policies associated with created CodeBuild project.  For that iam policy refer to:

* [Role DSL]({% link _docs/dsl/role.md %})

{% include prev_next.md %}
