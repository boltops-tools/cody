# Type Option

By default, the codebuild tool looks up files in the `.codebuild` folder.  You can affect the behavior of the lookup logic with the `--type` option.

## Examples

    cb deploy --type deploy

This will look up buildspec.yml, project.rb, and role.rb files in the `.codebuild/deploy` folder. So:

    .codebuild/deploy/buildspec.yml
    .codebuild/deploy/project.rb
    .codebuild/deploy/role.rb

Likewise `cb deploy --type unit` would result in:

    .codebuild/unit/buildspec.yml
    .codebuild/unit/project.rb
    .codebuild/unit/role.rb

## Type Stack Name

The CloudFormation stack name is appended with the name of the type option. So if you project folder is `demo` and the type option is `unit`.

    cd demo # project folder
    cb deploy --type deploy

It produces an inferred stack name of `demo-cb-deploy-development`.  You can override the CloudFormation stack name by specifying the project name explicitly.  The project name is an optional first argument. Here's an example:

    cd demo # project folder
    cb deploy demo-web --type deploy # stack name: demo-web-cb-deploy-development

You can also override the stack name with the `--stack-name` option.