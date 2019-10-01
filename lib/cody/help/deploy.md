## Examples

    cody deploy PROJECT_NAME # explicitly specify project-name
    cody deploy # infers the CodeBuild name from the parent folder

It is useful to just see the generated CloudFormation template with `--noop` mode:

    cody deploy PROJECT_NAME --noop # see generated CloudFormation template

## Types

By default, the codebuild tool looks up files in the `.codebuild` folder.  Example:

    .codebuild/buildspec.yml
    .codebuild/project.rb
    .codebuild/role.rb

### Examples

    cody deploy PROJECT_NAME --type deploy

This will look up buildspec.yml, project.rb, and role.rb files in the `.codebuild/deploy` folder. So:

    .codebuild/deploy/buildspec.yml
    .codebuild/deploy/project.rb
    .codebuild/deploy/role.rb

Likewise `cody deploy PROJECT_NAME --type unit` would result in:

    .codebuild/unit/buildspec.yml
    .codebuild/unit/project.rb
    .codebuild/unit/role.rb
