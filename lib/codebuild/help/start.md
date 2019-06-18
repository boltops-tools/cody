# Examples

    cb start # infers the name from the parent folder
    cb start stack-name # looks up project via CloudFormation stack
    cb start demo-project # looks up project via codebuild project name

## Overriding Env Variables at Runtime

You can override env variables at runtime with `--env-vars`. Examples:

    cb start --type vpc --env-vars K1=v1 K2=v2
    cb start --type vpc --env-vars K1=v1 K2=ssm:v2
