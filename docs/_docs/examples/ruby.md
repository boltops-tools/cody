---
title: Ruby
nav_text: Ruby
categories: example
nav_order: 18
---

This examples show to run Ruby unit tests.

Here's the project DSL.

.cody/project.rb:


```ruby
github_url("https://github.com/username/repo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
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
    commands:
      - apt-get update -y && apt-get install -y rsync
  build:
    commands:
      - echo Build started on `date`
      - sed -i '/BUNDLED WITH/Q' Gemfile.lock # hack to fix bundler issue: allow different versions of bundler to work
      - bundle
      - JETS_ENV=test bundle exec rspec
```

{% include examples-steps.md %}

{% include prev_next.md %}
