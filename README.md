# Codebuild

![Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiSUFzNE9RV3ROWmNKOHh2NG1wTjNmRlV4dnlOTnVrK3U2UFMrOEJRUGE2WS9mcjRWS0o1bjdSZlN5bG1tR1YyYVFlNkErTGdkbThsWExUaVJvWU1PRUY4PSIsIml2UGFyYW1ldGVyU3BlYyI6InppWWxJRGFiWHN1bEtYSzIiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
[![Gem Version](https://badge.fury.io/rb/codebuild.png)](http://badge.fury.io/rb/codebuild)

The codebuild tool provides a DSL to create a CodeBuild project with some reasonable defaults.

The codebuild tool installs `cb` and `codebuild` executables. Both of them do the same thing, `cb` is just shorter to type.

The documentation site is at: [codebuild.cloud](https://codebuild.cloud/)

## Quick Start

    cb init
    cb deploy
    cb start

## Private Repo

IMPORTANT: Before deploying, if you are using a private repo, use [aws codebuild import-source-credentials](https://docs.aws.amazon.com/cli/latest/reference/codebuild/import-source-credentials.html) to add credentials so that codebuild can clone down the repo.  Refer to the [CodeBuilld Github Oauth/](https://codebuild.cloud/docs/github_oauth/) for more info.

## Usage

1. **init**: generate starter .codebuild files.
2. **deploy**: deploy the CodeBuild project on AWS.
3. **start**: kick off a CodeBuild project run.

### Init and Structure

First, run `codebuild init` to generate a starter .codebuild structure.

    $ tree .codebuild
    .codebuild
    ├── buildspec.yml
    ├── project.rb
    └── role.rb

File | Description
--- | ---
buildspec.yml | The build commands to run.
project.rb | The codebuild project written as a DSL.
role.rb | The IAM role associated with the codebuild project written as a DSL.

### Deploy

Adjust the files in `.codebuild` to fit your needs. When you're ready, deploy the CodeBuild project with:

    cb deploy STACK_NAME

More examples:

    cb deploy # infers the CloudFormation name from the parent folder
    cb deploy stack-name # explicitly specify stack name

It is useful to just see the generated CloudFormation template with `--noop` mode:

    cb deploy --noop # see generated CloudFormation template

For more help:

    cb deploy -h

### Start

When you are ready to start a codebuild project run, you can use `codebuild start`. Examples:

    cb start # infers the name from the parent folder
    cb start stack-name # looks up project via CloudFormation stack
    cb start demo-project # looks up project via CodeBuild project name

The `cb start` command understands multiple identifiers. It will look up the codebuild project either via CloudFormation or the CodeBuild project name.

## Project DSL

The tool provides a DSL to create a codebuild project.  Here's an example.

.codebuild/project.rb:

```ruby
# name("demo") # recommended to leave unset and use the conventional name that cb tool sets
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  UFO_ENV: "development",
  API_KEY: "ssm:/codebuild/demo/api_key" # ssm param example
)
```

Here's a list of some of the convenience shorthand DSL methods:

* github_url(url)
* github_source(options={})
* linux_image(name)
* linux_environment(options={})
* environment_variables(vars)
* local_cache(enable=true)

Please refer to [lib/codebuild/dsl/project.rb](lib/codebuild/dsl/project.rb) for the full list.

More slightly more control, you may be interested in the `github_source` and `linux_environment` methods.  For even more control, see [DSL docs](https://codebuild.cloud/docs/dsl/).

## IAM Role DSL

The codebuild tool can create the IAM service role associated with the codebuild project. Here's an example:

.codebuild/role.rb:

```ruby
iam_policy("logs", "ssm")
```

For more control, here's a longer form:

```ruby
iam_policy(
  action: [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "ssm:*",
  ],
  effect: "Allow",
  resource: "*"
)
```

You can also create managed iam policy.

```ruby
managed_iam_policy("AmazonS3ReadOnlyAccess")
```

## Schedule Support

.codebuild/schedule.rb:

```ruby
rate "1 day"
```

## Full DSL

The convenience DSL methods shown above are short and clean.  They merely wrap a DSL that map to the properties of CloudFormation resources like [AWS::CodeBuild::Project](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html) and [AWS::IAM::Role](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html). Refer the [DSL docs](https://codebuild.cloud/docs/dsl/) for more info.

## Type Option

By default, the codebuild tool looks up files in the `.codebuild` folder.  You can affect the behavior of the Type logic with the `--Type` option.  More info [Type docs](https://codebuild.cloud/docs/type-option/).

## Installation

Add this line to your application's Gemfile:

    gem "codebuild"

And then execute:

    bundle

Or install it yourself as:

    gem install codebuild

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
