# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.6.3]
- add aws_data gem dependency

## [0.6.2]
- add s3 read-only access to default role
- fix settings

## [0.6.1]
- cb init: no variables by default
- fix handle rollback

## [0.6.0]
- named stack with -cb at the very end
- add docs
- cb init --no-variables option

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
- type option for subprojects in .codebuild folder
- update to zeitwerk for autoloading

## [0.2.0]
- First good release.
- Project and Role DSL
- codebuild commands: init, deploy, start
- lookup path support
- Docs in main readme and readme folder

## [0.1.0]
- Initial release.
