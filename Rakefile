require "bundler/gem_tasks"
require "rspec/core/rake_task"

task default: :spec

RSpec::Core::RakeTask.new

require_relative "lib/codebuild"
require "cli_markdown"
desc "Generates cli reference docs as markdown"
task :docs do
  CliMarkdown::Creator.create_all(cli_class: Codebuild::CLI, cli_name: "cb")
end
