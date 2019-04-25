# Codebuild

Tool creates a CodeBuild project with some reasonable defaults. It provides a DSL that can be used to create and override any setting required.

## Summarized Usage

    codebuild init
    codebuild deploy
    codebuild start

## Usage

First, run `codebuild init` to generate a starter .codebuild structure.

    $ tree .codebuild
    .codebuild
    ├── buildspec.yml
    ├── project.rb
    └── role.rb

File | Description
--- | ---
buildspec.yml | The build commands to run.
project.rb | The DSL that defines the codebuild project.
role.rb | The DSL that defines the IAM role assocaited with the codebuild project.

## Project DSL

The tool provides a DSL to create a codebuild project.  Here's an example.

.codebuild/project.rb:

```ruby
name("demo")
github_location("https://github.com/tongueroo/demo-ufo")
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
iam_statement(
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

The convenience is shorter and cleaner, however you have access to a "Full" DSL if needed. The convenience methods merely wrap properties of CloudFormation resources like [AWS::CodeBuild::Project](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html).

Refer the the [Full DSL docs](readme/full_dsl.md) for more info.

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
