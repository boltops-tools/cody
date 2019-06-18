# IAM Role DSL

The convenience methods merely wrap properties of the [AWS::IAM::Role
 CloudFormation Resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html).  If you wanted to set the CloudFormation properties more directly, here's an example of using the "Full" DSL.

.codebuild/role.rb:

```ruby
assume_role_policy_document(
  statement: [{
    action: ["sts:AssumeRole"],
    effect: "Allow",
    principal: {
      service: ["codebuild.amazonaws.com"]
    }
  }],
  version: "2012-10-17"
)
path("/")
policies([{
  policy_name: "CodeBuildAccess",
  policy_document: {
    version: "2012-10-17",
    statement: [{
      action: [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ],
      effect: "Allow",
      resource: "*"
    }]
  }
}])
```
