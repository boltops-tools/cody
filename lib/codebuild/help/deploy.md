## Examples

    codebuild deploy # infers the CloudFormation name from the parent folder
    codebuild deploy stack-name # explicitly specify stack name

It is useful to just see the generated CloudFormation template with `--noop` mode:

    codebuild deploy --noop # see generated CloudFormation template
