---
title: Variables Support
nav_order: 7
---

Cody supports the concept of variables. Variables allow you to set environment-specific variables. For example, development and production environments usually require the same code with different environmental variables.

Within the `.cody/variables` folder, you can create variable files and the variables defined in them are made available to your `.cody` DSL files.

    .cody/project.rb
    .cody/role.rb
    .cody/schedule.rb

## Structure

Here's an example variables structure:

    .cody
    └── variables
        ├── base.rb
        ├── development.rb
        └── production.rb

## Layering Support

The variable files are layered together. The `base.rb` and specific `CODY_ENV `variable file, like `development.rb`, are combined. An example helps explain.   Let's say you have these files:

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

    cody deploy # defaults to CODY_ENV=development

Since `CODY_ENV=development` is the default, this means `@myvar = "development-value"` is used.

If we want to use production values, then we can set `CODY_ENV=production`

    CODY_ENV=production cody deploy

In this case, `@myvar = "production-value"` is used.

Now if we use `CODY_ENV=staging`

    CODY_ENV=staging cody deploy

In this case, `@myvar = "base-value"` is used, since there is no `staging.rb` file.

## Variables with -\-type Option

With codebuild, we can use a `--type` option to create additional codebuild projects under the `.cody` folder.  Here's a short example:

    cody deploy --type deploy

The buildspec file it'll use is here:

    .cody/deploy/buildspec.yml

More info on the type option is here: [Type Option]({% link _docs/type-option.md %}).

Specific project type variables can be set. For example, let's say you have a `--type=deploy`, the variable files that will be used are:

    .cody/deploy/variables/base.rb
    .cody/deploy/variables/developemnt.rb

The type specific variable files override the top-level variable files. Type specific variable files get loaded last so they take the highest precedence.  Example:

    .cody/variables/base.rb - lowest precedence
    .cody/variables/developemnt.rb
    .cody/deploy/variables/base.rb
    .cody/deploy/variables/developemnt.rb - highest precedence

The top-level variables files are also loaded because it is common to need variables that are available to all projects.

## VPC and Migrations Example

A good variables example is running migrations. The migration tasks usually requires access to the VPC to connect to the database. However, the development and production resources can be on separate VPCs.  Variables can help here:

.cody/variables/development.rb:

```ruby
@vpc_config = { vpc_id: "vpc-aaa", subnets: ["subnet-aaa"], security_group_ids: ["sg-111"]  }
```

.cody/variables/production.rb:

```ruby
@vpc_config = { vpc_id: "vpc-bbb", subnets: ["subnet-bbb"], security_group_ids: ["sg-222"]  }
```

You'll use then `@vpc_config` variable in the `project.rb`.

.cody/project.rb:

```ruby
github_url("https://github.com/tongueroo/demo-ufo")
linux_image("aws/codebuild/amazonlinux2-x86_64-standard:2.0")
vpc_config @vpc_config
```

{% include prev_next.md %}
