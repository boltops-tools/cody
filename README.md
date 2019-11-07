<div align="center">
  <a href="http://cody.run"><img src="https://raw.githubusercontent.com/tongueroo/cody/master/docs/img/logos/cody-with-text.png" /></a>
</div>

# Cody

![Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiWWFRbjVNQlIvZGtSS2NMTGlRY3pWYm1lTGFFSG5acDc4b09hL2lHWGVxeHZaMGYxVTc0cGEwOHBHWHF6MjZiNlZNU0JqS0lvTnZkdWI5enRDczRZYStnPSIsIml2UGFyYW1ldGVyU3BlYyI6ImsyUDJNc2E3SlpYOGFYYy8iLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
[![Gem Version](https://badge.fury.io/rb/cody.png)](http://badge.fury.io/rb/cody)

Cody lets you create a AWS CodeBuild projects with a beautiful DSL.

The documentation site is at: [cody.run](https://cody.run/)

## Quick Start

    cody init
    cody deploy
    cody start

## Private Repo

IMPORTANT: Before deploying, if you are using a private repo, use [aws codebuild import-source-credentials](https://docs.aws.amazon.com/cli/latest/reference/codebuild/import-source-credentials.html) to add credentials so that codebuild can clone down the repo.  Refer to the [CodeBuilld Github Oauth/](https://cody.run/docs/github_oauth/) for more info.

## Usage

1. **init**: generate starter .cody files.
2. **deploy**: deploy the CodeBuild project on AWS.
3. **start**: kick off a CodeBuild project run.

### Init and Structure

First, run `cody init` to generate a starter `.cody` folder structure.

    $ tree .cody
    .cody
    ├── buildspec.yml
    ├── project.rb
    └── role.rb

File | Description
--- | ---
buildspec.yml | The build commands to run.  Here are the [buildspec.yml syntax docs](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html).
project.rb | The codebuild project written as a DSL. Here are the [Project DSL docs](https://cody.run/docs/dsl/project/)
role.rb | The IAM role associated with the codebuild project written as a DSL. Here are the [IAM Role DSL docs](https://cody.run/docs/dsl/role/)

### Deploy

Adjust the files in `.cody` to fit your needs. When you're ready, deploy the CodeBuild project with:

    cody deploy PROJECT_NAME

More examples:

    cody deploy # infers the CodeBuild project name from the parent folder
    cody deploy PROJECT_NAME # explicitly specify project name

It is useful to just see the generated CloudFormation template with `--noop` mode:

    cody deploy --noop # see generated CloudFormation template

For more help:

    cody deploy -h

### Start

When you are ready to start a codebuild project run, you can use `codebuild start`. Examples:

    cody start # infers the name from the parent folder
    cody start PROJECT_NAME # looks up project via CodeBuild project name

The `cody start` command understands multiple identifiers. It will look up the codebuild project either via CloudFormation or the CodeBuild project name.

## Project DSL

The tool provides a DSL to create a codebuild project.  Here's an example.

.cody/project.rb:

```ruby
# name("demo") # recommended to leave unset and use the conventional name that cody sets
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

More slightly more control, you may be interested in the `github_source` and `linux_environment` methods.  For even more control, see [DSL docs](https://cody.run/docs/dsl/).

## IAM Role DSL

Cody can create the IAM service role associated with the codebuild project. Here's an example:

.cody/role.rb:

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

.cody/schedule.rb:

```ruby
rate "1 day"
```

## Full DSL

The convenience DSL methods shown above are short and clean.  They merely wrap a DSL that map to the properties of CloudFormation resources like [AWS::CodeBuild::Project](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html) and [AWS::IAM::Role](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html). Refer the [DSL docs](https://cody.run/docs/dsl/) for more info.

## Type Option

By default, cody looks up files in the `.cody` folder.  You can affect the behavior of the Type logic with the `--Type` option.  More info [Type docs](https://cody.run/docs/type-option/).

## Installation

Add this line to your application's Gemfile:

    gem "cody"

And then execute:

    bundle

Or install it yourself as:

    gem install cody

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
