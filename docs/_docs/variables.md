---
title: Variables Support
nav_order: 5
---

The codebuild tool supports the concept of variables. Variables allow you to set environment-specific variables. For example, development and production environments usually require the same code with different environmental variables.

Within the `.codebuild/variables` folder, you can create variable files and the variables defined in them are made available to your `.codebuild` DSL files.

    .codebuild/project.rb
    .codebuild/role.rb
    .codebuild/schedule.rb

## Structure

Here's an example variables structure:

    .codebuild
    └── variables
        ├── base.rb
        ├── development.rb
        └── production.rb

## Layering Support

The variable files are layered together. The `base.rb` and specific `CB_ENV `variable file, like `development.rb`, are combined. An example helps explain.   Let's say you have these files:

base.rb:

```ruby
@myvar = "base-value"
```

development.rb:

```ruby
@myvar = "development-value"
```

production.rb:

```ruby
@myvar = "production-value"
```

Then you can do this:

    cb deploy # defaults to CB_ENV=development

Since `CB_ENV=development` is the default, this means `@myvar = "development-value"` is used.

If we want to use production values, then we can set `CB_ENV=production`

    CB_ENV=production cb deploy

In this case, `@myvar = "production-value"` is used.

Now if we use `CB_ENV=staging`

    CB_ENV=staging cb deploy

In this case, `@myvar = "base-value"` is used, since there is no `staging.rb` file.

## Variables with -\-type Option

With codebuild, we can use a `--type` option to create additional codebuild projects under the `.codebuild` folder.  Here's a short example:

    cb deploy --type deploy

The buildspec file it'll use is here:

    .codebuild/deploy/buildspec.yml

More info on the type option is here: [Type Option]({% link _docs/type-option.md %}).

Specific project type variables can be set. For example, let's say you have a `--type=deploy`, the variable files that will be used are:

    .codebuild/deploy/variables/base.rb
    .codebuild/deploy/variables/developemnt.rb

The type specific variable files override the top-level variable files. Type specific variable files get loaded last so they take the highest precedence.  Example:

    .codebuild/variables/base.rb - lowest precedence
    .codebuild/variables/developemnt.rb
    .codebuild/deploy/variables/base.rb
    .codebuild/deploy/variables/developemnt.rb - highest precedence

The top-level variables files are also loaded because it is common to need variables that are available to all projects.

## VPC and Migrations Example

An good variables example is running migrations. The migration tasks usually requires access to the VPC to connect to the database. However, the development and production resources can be on separate VPCs.  Variables can help here:

.codebuild/variables/development.rb:

```ruby
@vpc_config = { vpc_id: "vpc-aaa", subnet_id: "subnet-aaa" }
```

.codebuild/variables/production.rb:

```ruby
@vpc_config = { vpc_id: "vpc-bbb", subnet_id: "subnet-bbb" }
```

You'll use then `@vpc_config` variable in the `buildspec.yml`.

.codebuild/buildspec.yml:

```ruby
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")
vpc_config @vpc_config
```

{% include prev_next.md %}
