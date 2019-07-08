## Examples

    cb init # infers the name from the parent folder
    cb init --name demo-codebuild-project # set the name

## Custom Templates

If you would like the `cb init` command to use your own custom templates, you can achieve this with the `--template` and `--template-mode` options.  Example:

    cb init --template=tongueroo/codebuild-custom-template

This will clone the repo on GitHub into the `~/.codebuild/templates/tongueroo/codebuild-custom-template` and use that as an additional template source.  The default `--template-mode=additive` mode means that if there's a file in `tongueroo/codebuild-custom-template` that exists it will use that in place of the default template files.

If you do not want to use any of the original default template files within the codebuild gem at all, you can use the `--template-mode=replace` mode. Replace mode will only use templates from the provided `--template` option.  Example:

    cb init --template=tongueroo/codebuild-custom-template --template-mode=replace

You can also specific the full GitHub url. Example:

    cb init --template=https://github.com/tongueroo/codebuild-custom-template

If you would like to use a local template that is not on GitHub, then created a top-level folder in `~/.codebuild/templates` without a subfolder. Example:

    cb init --template=my-custom # uses ~/.codebuild/templates/my-custom
