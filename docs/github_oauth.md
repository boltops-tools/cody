# GitHub Oauth Token

Thought that we need to set the oauth token as part of the CloudFormation template source property under [AWS CodeBuild Project SourceAuth](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-sourceauth.html). However, that did not seem to work.

Instead this guide [Using Access Tokens with Your Source Provider in CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-access-tokens.html) with [aws codebuild import-source-credentials](https://docs.aws.amazon.com/cli/latest/reference/codebuild/import-source-credentials.html) worked.

## Create the GitHub Oauth Token

One way to create an GitHub oauth token:

1. Go to GitHub
2. Settings
3. Developer Settings
4. Personal access tokens

IMPORTANT: If using webhook, the oauth token needs `admin:repo_hook` also.  To check this, you can log into the github, go to the repo, and see if you have access to the "Settings" tab.

![](https://raw.githubusercontent.com/tongueroo/codebuild/master/img/github-admin-settings-tab.png)

## Commands

Here are the import-source-credentials commands for posterity.

Save the GitHub oauth token to parameter store, in case we need it in the future.

    aws ssm put-parameter --name /codebuild/github/oauth_token --value secret-token-value --type SecureString

Import the source credential into codebuild.

    TOKEN=$(aws ssm get-parameter --name /codebuild/github/oauth_token --with-decryption | jq -r '.Parameter.Value')
    cat > /tmp/codebuild-source-credentials.json <<EOL
    {
        "token": "$TOKEN",
        "serverType": "GITHUB",
        "authType": "PERSONAL_ACCESS_TOKEN"
    }
    EOL
    aws codebuild import-source-credentials --cli-input-json file:///tmp/codebuild-source-credentials.json
    aws codebuild list-source-credentials
