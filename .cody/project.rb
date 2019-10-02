github_url("https://github.com/tongueroo/cody")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
triggers(webhook: true)
local_cache(false)