github_url("https://github.com/tongueroo/cody")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
triggers(
  webhook: true,
  filter_groups: [[{type: "EVENT", pattern: "PUSH"}]]
)
local_cache(false)