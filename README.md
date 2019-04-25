# Codebuild

Tool creates a CodeBuild project with some reasonable defaults. It provides a DSL that can be used to create and override any setting required.

## Summarized Usage

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

Adjust the files in `.codebuild` to you needs. When you're read deploy the CodeBuild project with:

    codebuild deploy STACK_NAME

More examples:

    codebuild deploy # infers the CloudFormation name from the parent folder
    codebuild deploy stack-name # explicitly specify stack name

It is useful to just see the generated CloudFormation template with `--noop` mode:

    codebuild deploy --noop # see generated CloudFormation template

### Start

When you are ready to start a codebuild project run, you can use `codebuild start`. Examples:

    codebuild start # infers the name from the parent folder
    codebuild start stack-name # looks up project via CloudFormation stack
    codebuild start demo-project # looks up project via codebuild project name

The `codebuild start` command understands multiple identifiers. It will look up the codebuild project either via CloudFormation or codebuild directly.

## Project DSL

The tool provides a DSL to create a codebuild project.  Here's an example.

.codebuild/project.rb:

```ruby
name("demo")
github_url("https://github.com/tongueroo/demo-ufo")
github_token(ssm("/codebuild/demo/oauth_token"))
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  UFO_ENV: "development",
  API_KEY: "ssm:/codebuild/demo/api_key"
)
```

The Project DSL methods are defined in the [lib/codebuild/dsl/project.rb](lib/codebuild/dsl/project.rb) class.

More slightly more control, you may be interested in the `github_source` and `linux_environment` methods.  For even more control, see "Full DSL".

## IAM Role DSL

The codebuild tool can create the IAM service role associated with the codebuild project. Here's an example:

.codebuild/role.rb:

```ruby
iam_policy("logs", "ssm")
```

For a longer form:

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

The convenience methods are shorter and cleaner, however you have access to a "Full" DSL if needed. The convenience methods merely wrap properties of CloudFormation resources like [AWS::CodeBuild::Project](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html) and [AWS::IAM::Role](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html). Refer the the [Full DSL docs](readme/full_dsl.md) for more info.

# Installation

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
