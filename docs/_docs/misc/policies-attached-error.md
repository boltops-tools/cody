---
title: Policy Attached to 0 entities Error
nav_order: 22
---

## The Issue

If the github webhook not working and you're seeing this error:

> The policy is attached to 0 entities but it must be attached to a single role

Here's a screenshot:

![](https://img.boltops.com/boltops/tools/cody/policies-attached/policies-attached-to-0-entities-error.png)

The CodeBuild console seems to be confused.  Believe the CodeBuild wizard tries to creates an conventional IAM policy and attaches it to the CodeBuild project. Cody creates an IAM role via code and attaches it to the the CodeBuild project though. Hence the confusion.

Now, if you're webhook is not working for whatever reason. Maybe it's out of sync on GitHub. Then CloudFormation doesn't seem to update the webhook.

## Workaround

A workaround is to delete both:

1. Service role permissions - by unchecking the checkbox
2. Primary source webhook events - by unchecking the checkbox

Screenshots provided below:

![](https://img.boltops.com/boltops/tools/cody/policies-attached/service-role-checkbox.png)

![](https://img.boltops.com/boltops/tools/cody/policies-attached/primary-source-webhook-events-checkbox.png)

Then make a slight change to the `.cody/project.rb` and run `cody deploy`.  You can just remove the webhook, deploy, add back the webhook and deploy again.  This syncs back up CodeBuild with CloudFormation and the webhook should be fixed.

## Resources

* [What to do if you get a "The policy is attached to 0 entities but it must be attached to a single role" error in aws](https://qiita.com/kyuaz/items/3da93bd05b1342212577) - Use google translate to convert from Japanese to English
* [Policy is attached to 0 entities](https://forums.aws.amazon.com/thread.jspa?messageID=833234)

{% include prev_next.md %}
