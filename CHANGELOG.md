# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [2.0.0] - unreleased
- .cody/role.rb renamed to .cody/iam_role.rb
- project dsl methods changed: new methods: github, image, env_vars
- cody up instead of cody deploy command
- CODY_ENV=dev default instead of CODY_ENV=development
- CloudFormation schedule event logical id changed. Results in the schedule event resource just being recreated.

## [1.1.0] - 2022-03-03
- [#33](https://github.com/tongueroo/cody/pull/33) fix cfn status when auto deleting rollback completed stack
- [#34](https://github.com/tongueroo/cody/pull/34) iam roles: support multiple calls
- update iam role docs

## [1.0.6] - 2021-12-17
- [#32](https://github.com/tongueroo/cody/pull/32) fix activesupport require
- fix warn not found ssm param message

## [1.0.5] - 2021-08-28
- add params overrides option
- docs: fix ecs permission, add iam:GetRole
- edge case: yaml has nothing but comments
- improve settings merge
- update vpc config exmaple with camelcase

## [1.0.4] - 2021-01-08
- loosen activesupport version pin

## [1.0.3] - 2021-01-08
- [#31](https://github.com/tongueroo/cody/pull/31) surface context message with error message for during provisioning fa…
- docs: update ci jets v3
- raise error option

## [1.0.2]
- #30 Allow multiple git providers

## [1.0.1]
- fix EventsRuleRole Service camelcase

## [1.0.0]
- Breaking changes: CamelCase for properties instead of underscore. Map straight to the CloudFormation resource to remove mental overhead.
- See: https://cody.run/docs/upgrading/
- Use unfrozen gems instead of vendors gems: aws_data, cfn-status, cfn_camelizer.
- Update templates to use the latest
- Restructure classes to use CLI namespace
- Change delete: `--sure` to `--yes` option. `-y` shorthand.
- Rename CODY_EXTRA env variable

## [0.9.8]
- add minimal deploy iam policy docs
- list: add --status filter option

## [0.9.7]
- #25 cody list: add sort-by option

## [0.9.6]
- #24 refactor: add dsl base class so `project_name` method is available to all dsl classes
- cody list: fix for projects with no builds yet

## [0.9.5]
- write info messsage to stderr so we can pipe to jq

## [0.9.4]
- #23 list command: add Time column

## [0.9.3]
- #22 add badge command

## [0.9.2]
- #21 update to amazonlinux2-x86_64-standard:2.0 image

## [0.9.1]
- list command improvement: show status also

## [0.9.0]
- #13,#14 setting a default region in the event that the AWS region is not set.
- #17 allow empty IAM Managed Policies
- #18 add status and list commands
- fix display failed phases

## [0.8.6]
- only print Failed Phases when there are failed phases

## [0.8.5]
- #12 display failed phases at the end if failed
- also dont sleep 10 if command is coming from logs

## [0.8.4]
- improve final message, report build_status

## [0.8.3]
- #11 sleep on error for cloudwatch logs
- also add `-t` alias for `--type` option

## [0.8.2]
- #9 add cody stop command
- #10 add evaluate interface methods

## [0.8.1]
- #8 report build time at end of logs

## [0.8.0]
- #7 add cody logs command and automatically tail logs after a cody start

## [0.7.3]
- cleanup starter buildspec.yml

## [0.7.2]
- add mfa support for normal IAM user

## [0.7.1]
- fix renaming

## [0.7.0]
- Rename to Cody
- Breaking changes: .cody folder, CODY_ENV, -cody stack name suffix

## [0.6.6]
- add mode option: bare and full

## [0.6.5]
- allow no settings.yml file

## [0.6.4]
- fix vendor gem dependencies in gem package

## [0.6.3]
- add aws_data gem dependency

## [0.6.2]
- add s3 read-only access to default role
- fix settings

## [0.6.1]
- cody init: no variables by default
- fix handle rollback

## [0.6.0]
- named stack with -cody at the very end
- add docs
- cody init --no-variables option

## [0.5.0]
- add --wait option
- change default append_env setting to false
- fix default iam policy

## [0.4.0]
- Add managed_iam_policy support
- #2 Add schedule dsl
- starter template fix: add settings.yml for correct cb project detection

## [0.3.0]
- rework cb cli interface
- project_name as cli main parameter
- type option for subprojects in .cody folder
- update to zeitwerk for autoloading

## [0.2.0]
- First good release.
- Project and Role DSL
- codebuild commands: init, deploy, start
- lookup path support
- Docs in main readme and readme folder

## [0.1.0]
- Initial release.
