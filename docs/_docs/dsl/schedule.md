---
title: Schedule DSL
nav_text: Schedule
categories: dsl
---

Cody supports creating a CloudWatch scheduled event rule that will trigger the codebuild project periodically.  You define the schedule in `.cody/schedule.rb`. Here's an example of what that looks like:

.cody/schedule.rb:

```ruby
rate "1 day"
# or
# cron("0 10 * * ? *") # Run at 10:00 am (UTC) every day
```

## Full DSL

The convenience methods merely wrap properties of the [AWS::Events::Rule](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-events-rule.html#cfn-events-rule-description).  If you wanted to set the CloudFormation properties more directly, here's an example of using the Full DSL.

.cody/schedule.rb:

```ruby
description "my description"
schedule_expression "rate(1 day)"
```