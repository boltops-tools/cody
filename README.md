# Codebuild

![Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoidHFFaithL1pLZWFEUzBXbk5LY05Mc0FrZW56NDVJWTArbUlOdzBUalVPWWZ5a1ZYUEFtTkhlbFBjeURRZEd1Q292WTI1RUJwWkcvdEgxUXhSYnBqVU9VPSIsIml2UGFyYW1ldGVyU3BlYyI6IjJ0dnpqMC9XMzQ4VExCMGgiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

Tool creates a CodeBuild project with some reasonable defaults. It provides a DSL that can be used to create and override setting if required.

## Quick Start

    codebuild init
    codebuild deploy
    codebuild start

## Usage

1. **init**: generate starter .codebuild files.
2. **deploy**: deploy the CodeBuild project on AWS.
3. **start**: kick off a CodeBuild project run.

### Init

First, run `codebuild init` to generate a starter .codebuild structure.

    $ tree .codebuild
    .codebuild
    ├── buildspec.yml
    ├── project.rb
    └── role.rb

File | Description
--- | ---
buildspec.yml | The build commands to run.
project.rb | The codebuild project defined as a DSL.
role.rb | The IAM role assocaited with the codebuild project defined as a DSL.

### Deploy

Adjust the files in `.codebuild` to fit your needs. When you're ready, deploy the CodeBuild project with:

    codebuild deploy STACK_NAME

More examples:

    codebuild deploy # infers the CloudFormation name from the parent folder
    codebuild deploy stack-name # explicitly specify stack name

It is useful to just see the generated CloudFormation template with `--noop` mode:

    codebuild deploy --noop # see generated CloudFormation template

For more help:

    codebuild deploy -h

### Start

When you are ready to start a codebuild project run, you can use `codebuild start`. Examples:

    codebuild start # infers the name from the parent folder
    codebuild start stack-name # looks up project via CloudFormation stack
    codebuild start demo-project # looks up project via CodeBuild project name

The `codebuild start` command understands multiple identifiers. It will look up the codebuild project either via CloudFormation or the CodeBuild project name.

## Project DSL

The tool provides a DSL to create a codebuild project.  Here's an example.

.codebuild/project.rb:

```ruby
name("demo")
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  UFO_ENV: "development",
  API_KEY: "ssm:/codebuild/demo/api_key"
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

More slightly more control, you may be interested in the `github_source` and `linux_environment` methods.  For even more control, see [Full DSL docs](readme/full_dsl.md).

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

## Full DSL

The convenience DSL methods shown above are short and clean.  They merely wrap a DSL that map to the properties of CloudFormation resources like [AWS::CodeBuild::Project](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html) and [AWS::IAM::Role](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html). Refer the [Full DSL docs](readme/full_dsl.md) for more info.

## Lookup Paths

By default, the codebuild tool looks up files in the `.codebuild` folder.  You can affect the behavior of the lookup logic with the `--lookup` option.  More info [Lookup docs](readme/lookup.md).

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
