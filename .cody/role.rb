iam_policy(
  action: [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "ssm:DescribeDocumentParameters",
    "ssm:DescribeParameters",
    "ssm:GetParameter*",
  ],
  effect: "Allow",
  resource: "*"
)

managed_iam_policy("AWSCloudFormationReadOnlyAccess")
