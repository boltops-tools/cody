---
title: IAM Role DSL
nav_text: IAM Role
categories: dsl
nav_order: 16
---

Cody can create the IAM service role associated with the codebuild project. Here's an example:

.cody/role.rb:

```ruby
iam_policy("logs", "ssm")
```

For more control, here's a longer form:

```ruby
iam_policy(
  Action: [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "ssm:*",
  ],
  Effect: "Allow",
  Resource: "*"
)
```

You can also make multiple calls to `iam_policy`. Example:

```ruby
iam_policy("logs")
lam_policy("ssm")
```

You can also create managed IAM policy.

```ruby
managed_iam_policy("AmazonS3ReadOnlyAccess")
```

You can also add multiple managed IAM policies:

```ruby
managed_iam_policy("AmazonS3ReadOnlyAccess", "AmazonEC2ReadOnlyAccess")
```

## Full DSL

The convenience methods merely wrap properties of the [AWS::IAM::Role
 CloudFormation Resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html).  If you wanted to set the CloudFormation properties more directly, here's an example of using the "Full" DSL.

.cody/role.rb:

```ruby
assume_role_policy_document(
  Statement: [{
    Action: ["sts:AssumeRole"],
    Effect: "Allow",
    Principal: {
      Service: ["codebuild.amazonaws.com"]
    }
  }],
  Version: "2012-10-17"
)
path("/")
policies([{
  PolicyName: "CodeBuildAccess",
  PolicyDocument: {
    Version: "2012-10-17",
    Statement: [{
      Action: [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ],
      Effect: "Allow",
      Resource: "*"
    }]
  }
}])
```

## Default IAM Role

Here's the default IAM Role that Cody uses.

```ruby
iam_policy(
  Action: [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "ssm:DescribeDocumentParameters",
    "ssm:DescribeParameters",
    "ssm:GetParameter*",
  ],
  Effect: "Allow",
  Resource: "*"
)
```

If you override default by creating a `role.rb` file, you will probably want to keep at least logs access so CodeBuild can write to CloudWatch.

{% include prev_next.md %}
