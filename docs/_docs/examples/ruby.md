---
title: Ruby
nav_text: Ruby
categories: example
nav_order: 19
---

This examples show to run Ruby unit tests.

Here's the project DSL.

.cody/project.rb:


```ruby
github_url("https://github.com/username/repo")
linux_image("aws/codebuild/amazonlinux2-x86_64-standard:2.0")
environment_variables(
  JETS_ENV: Cody.env,
)
```

Here's the buildspec:

.cody/buildspec.yml

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      ruby: 2.6
    commands:
      - apt-get update -y && apt-get install -y rsync
  build:
    commands:
      # keep sed comment for older versions of ruby
      - # sed -i '/BUNDLED WITH/Q' Gemfile.lock # hack to fix bundler issue: allow different versions of bundler to work.
      - bundle
      - JETS_ENV=test bundle exec rspec
```

{% include examples-steps.md %}

{% include prev_next.md %}
