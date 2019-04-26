# For methods, refer to the properties of the CloudFormation CodeBuild::Project https://amzn.to/2UTeNlr
# For convenience methods, refer to the source https://github.com/tongueroo/codebuild/blob/master/lib/codebuild/dsl/project.rb

# Note: for the oauth_token, you have to set this parameter in ssm parameter store
# One way to create an GitHub oauth token:
# Go to GitHub / Settings / Developer Settings / Personal access tokens
# If using webhook, the oauth token needs admin:repo_hook

name("codebuild")
github_url("https://github.com/tongueroo/codebuild")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  JETS_ENV: "test",
)
triggers(webhook: true)
local_cache(false)