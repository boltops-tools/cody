# Lookup Paths

By default, the codebuild tool looks up files in the `.codebuild` folder.  You can affect the behavior of the lookup logic with the `--lookup` option.

## Example 1

    codebuild deploy --lookup unit

This will look up buildspec.yml, project.rb, and role.rb files in the `.codebuild/unit` folder first. If files are found, then it will use those files in that folder. If not found, it'll fall back to the `.codebuild` parent folder.

Lookup order with `--lookup unit` for `buildspec.yml`:

1. .codebuild/unit/buildspec.yml
2. .codebuild/buildspec.yml

Lookup order with `--lookup unit` for `project.rb`:

1. .codebuild/unit/project.rb
2. .codebuild/project.rb

The same goes other files in the `.codebuild` like `role.rb`.

## Example 2

Here's another example:

    codebuild deploy --lookup deploy

Lookup order with `--lookup deploy` for `buildspec.yml`:

1. .codebuild/deploy/buildspec.yml
2. .codebuild/buildspec.yml

The same goes other files in the `.codebuild` like `project.rb` and `role.rb`.
