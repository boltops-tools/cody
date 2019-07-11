---
title: Schedule DSL
nav_text: Schedule
categories: dsl
nav_order: 14
---

The codebuild tool supports creating a CloudWatch scheduled event rule that will trigger the codebuild project periodically.  You define the schedule in `.codebuild/schedule.rb`. Here's an example of what that looks like:

.codebuild/schedule.rb:

```ruby
rate "1 day"
# or
cron("0 10 * * ? *") # Run at 10:00 am (UTC) every day
```

## Full DSL

The convenience methods merely wrap properties of the [AWS::Events::Rule](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-events-rule.html#cfn-events-rule-description).  If you wanted to set the CloudFormation properties more directly, here's an example of using the Full DSL.

.codebuild/schedule.rb:

```ruby
description "my description"
schedule_expression "rate(1 day)"
```

{% include prev_next.md %}