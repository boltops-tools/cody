# Examples

    cody start # infers the name from the parent folder
    cody start stack-name # looks up project via CloudFormation stack
    cody start demo-project # looks up project via codebuild project name

## Overriding Env Variables at Runtime

You can override env variables at runtime with `--env-vars`. Examples:

    cody start --type vpc --env-vars K1=v1 K2=v2
    cody start --type vpc --env-vars K1=v1 K2=ssm:v2 # support for PARAMETER_STORE
