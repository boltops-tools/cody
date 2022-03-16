require 'cli-format'

module Cody
  class CLI < Command
    include Help

    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "init", "Generate initial .cody files"
    long_desc Help.text(:init)
    New::Init.cli_options.each do |args|
      option(*args)
    end
    register(New::Init, "init", "init", "Generate initial .cody files")

    common_options = Proc.new do
      option :type, aliases: "t", desc: "folder to use within .cody folder for different build types"
      option :stack_name, desc: "Override the generated stack name. If you use this you must always specify it"
      option :wait, type: :boolean, default: true, desc: "Wait for operation to complete"
    end
    yes_option = Proc.new do
      option :yes, aliases: :y, type: :boolean, desc: "Bypass are you sure prompt"
    end

    desc "build", "build codebuild project"
    long_desc Help.text(:build)
    common_options.call
    def build(project_name=nil)
      Cody::Builder.new(options.merge(project_name: project_name)).run
    end

    desc "up", "Deploy CodeBuild CloudFormation Template"
    long_desc Help.text(:up)
    common_options.call
    yes_option.call
    def up(project_name=nil)
      Cody::Stack.new(options.merge(project_name: project_name)).run
    end

    desc "down", "down codebuild project"
    long_desc Help.text(:down)
    common_options.call
    yes_option.call
    def down(project_name=nil)
      Down.new(options.merge(project_name: project_name)).run
    end

    desc "start", "start codebuild project"
    long_desc Help.text(:start)
    option :branch, aliases: "b", desc: "git branch" # Default is nil. Will use what's configured on AWS CodeBuild project settings.
    option :secondary_branches, type: :hash, desc: "secondary git branches. IE: App:feature1"
    option :env_vars, aliases: "e", type: :array, desc: "env var overrides. IE: KEY1=VALUE1 KEY2=VALUE2"
    common_options.call
    yes_option.call
    def start(project_name=nil)
      Start.new(options.merge(project_name: project_name)).run
    end

    desc "status", "status of codebuild project"
    long_desc Help.text(:status)
    option :build_id, desc: "Project build id. Defaults to most recent"
    common_options.call
    def status(project_name=nil)
      Status.new(options.merge(project_name: project_name)).run
    end

    desc "stop", "stop codebuild project"
    long_desc Help.text(:stop)
    option :build_id, desc: "Project build id. Defaults to most recent"
    common_options.call
    def stop(project_name=nil)
      Stop.new(options.merge(project_name: project_name)).run
    end

    desc "list", "list codebuild project"
    long_desc Help.text(:list)
    option :format, desc: "Output formats: #{CliFormat.formats.join(', ')}"
    option :sort_by, desc: "Sort by column: name, status, time"
    option :status, desc: "status filter. IE: SUCCEEDED, FAILED, FAULT, TIMED_OUT, IN_PROGRESS, STOPPED. Both upper and lowercase works"
    option :select, desc: "select filter on the project name. The select option gets converted to an Ruby regexp"
    def list
      List.new(options).run
    end

    desc "logs", "Prints out logs for codebuild project"
    long_desc Help.text(:logs)
    option :build_id, desc: "Project build id. Defaults to most recent"
    option :since, desc: "From what time to begin displaying logs.  By default, logs will be displayed starting from 7 days in the past. The value provided can be an ISO 8601 timestamp or a relative time"
    common_options.call
    def logs(project_name=nil)
      Logs.new(options.merge(project_name: project_name)).run
    end

    desc "badge", "show the codebuild badge"
    long_desc Help.text(:list)
    option :markdown, default: true, type: :boolean, desc: "Show the markdown that can be copied and pasted"
    common_options.call
    def badge(project_name=nil)
      Badge.new(options.merge(project_name: project_name)).run
    end

    desc "version", "prints version"
    def version
      puts VERSION
    end
  end
end
