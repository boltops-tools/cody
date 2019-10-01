## Examples

    cody init # infers the name from the parent folder
    cody init my-project # set the name

## Type Option

The type option is useful to generate subfolder under .codebuild that contain another codebuild project.  Example:

    cody init --type unit

Thi generates the cb files under the `.codebuild/unit` folder.

    .codebuild
    └── unit
        ├── buildspec.yml
        └── project.rb

To tell the codebuild tool to use these files, you specify the `--type` option as a part of the other commands. Examples:

    cody deploy --type unit
    cody start --type unit

## Structure

So if you need multiple CodeBuild projects that perform different tasks but are both related to the same code repo, you might have a structure like this:

    .codebuild
    ├── deploy
    │   ├── buildspec.yml
    │   └── project.rb
    └── unit
        ├── buildspec.yml
        └── project.rb

## Mode Option

By default, `cody init` generates a very lightweight structure.  You can have it also generate a "full" structure with the `--mode` option.  Example.

    $ cody init --mode full
    $ tree .codebuild
    .codebuild
    ├── buildspec.yml
    ├── project.rb
    ├── role.rb
    ├── schedule.rb
    ├── settings.yml
    └── variables
        ├── base.rb
        ├── development.rb
        └── production.rb

## Custom Templates

If you would like the `cody init` command to use your own custom templates, you can achieve this with the `--template` and `--template-mode` options.  Example:

    cody init --template=tongueroo/codebuild-custom-template

This will clone the repo on GitHub into the `~/.codebuild/templates/tongueroo/codebuild-custom-template` and use that as an additional template source.  The default `--template-mode=additive` mode means that if there's a file in `tongueroo/codebuild-custom-template` that exists it will use that in place of the default template files.

If you do not want to use any of the original default template files within the codebuild gem at all, you can use the `--template-mode=replace` mode. Replace mode will only use templates from the provided `--template` option.  Example:

    cody init --template=tongueroo/codebuild-custom-template --template-mode=replace

You can also specific the full GitHub url. Example:

    cody init --template=https://github.com/tongueroo/codebuild-custom-template

If you would like to use a local template that is not on GitHub, then created a top-level folder in `~/.codebuild/templates` without a subfolder. Example:

    cody init --template=my-custom # uses ~/.codebuild/templates/my-custom
