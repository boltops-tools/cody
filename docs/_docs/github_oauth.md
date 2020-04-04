---
title: GitHub Oauth Token
nav_order: 10
---

This page covers how to set up the GitHub oauth token that CodeBuild uses.

CloudFormation docs has an oauth token property as part of the CloudFormation template source property under [AWS CodeBuild Project SourceAuth](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-sourceauth.html). It does not seem to work though.


Note: Am hoping that have either tested this incorrectly or that AWS fixes the bug.

Instead, this guide [Using Access Tokens with Your Source Provider in CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-access-tokens.html) with [aws codebuild import-source-credentials](https://docs.aws.amazon.com/cli/latest/reference/codebuild/import-source-credentials.html) works.

## Create the GitHub Oauth Token

Here are the steps to create a GitHub oauth token:

1. Go to GitHub
2. Settings
3. Developer Settings
4. Personal access tokens

IMPORTANT: If using webhook, the oauth token needs `admin:repo_hook` also.  To check this, you can log into the github, go to the repo, and see if you have access to the "Settings" tab.

![](https://raw.githubusercontent.com/tongueroo/cody/master/img/github-admin-settings-tab.png)

## Commands

Here's a guide to using the `import-source-credentials` commands.

First, save the GitHub oauth token to parameter store, in case we need it in the future.

    aws ssm put-parameter --name /github/USER/token --value secret-token-value --type SecureString

Replace `USER` with the github username. IE:

    aws ssm put-parameter --name /github/tongueroo/token --value secret-token-value --type SecureString

Import the source credential into codebuild, here's an example with `USER=tongueroo`.

    TOKEN=$(aws ssm get-parameter --name /github/tongueroo/token --with-decryption | jq -r '.Parameter.Value')
    cat > /tmp/codebuild-source-credentials.json <<EOL
    {
        "token": "$TOKEN",
        "serverType": "GITHUB",
        "authType": "PERSONAL_ACCESS_TOKEN"
    }
    EOL
    aws codebuild import-source-credentials --cli-input-json file:///tmp/codebuild-source-credentials.json
    aws codebuild list-source-credentials

Setting this sets the oauth token used by the CodeBuild projects.

{% include prev_next.md %}
