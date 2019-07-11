---
title: Ruby
nav_text: Ruby
categories: example
nav_order: 18
---

This examples show to run ruby unit tests.

Here's the project DSL.

.codebuild/project.rb:


```ruby
github_url("https://github.com/username/repo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
environment_variables(
  JETS_ENV: Codebuild.env,
)
```

Here's the buildspec:

.codebuild/buildspec.yml

```yaml
version: 0.2

phases:
  install:
    commands:
      - apt-get update -y && apt-get install -y rsync # prequisite for jets
  build:
    commands:
      - echo Build started on `date`
      - sed -i '/BUNDLED WITH/Q' Gemfile.lock # hack to fix bundler issue: allow different versions of bundler to work
      - gem install bundler:1.16.6
      - export JETS_ENV=test
      - bundle
      - bundle exec rspec
```

{% include prev_next.md %}