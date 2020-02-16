module Cody
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "init", "Initialize project with .cody files"
    long_desc Help.text(:init)
    Init.cli_options.each do |args|
      option(*args)
    end
    register(Init, "init", "init", "Set up initial .cody files.")

    common_options = Proc.new do
      option :type, aliases: "t", desc: "folder to use within .cody folder for different build types"
      option :stack_name, desc: "Override the generated stack name. If you use this you must always specify it"
      option :wait, type: :boolean, default: true, desc: "Wait for operation to complete"
    end

    desc "deploy", "Deploy codebuild project."
    long_desc Help.text(:deploy)
    common_options.call
    def deploy(project_name=nil)
      Deploy.new(options.merge(project_name: project_name)).run
    end

    desc "delete", "Delete codebuild project."
    long_desc Help.text(:delete)
    option :sure, desc: "Bypass are you sure prompt"
    common_options.call
    def delete(project_name=nil)
      Delete.new(options.merge(project_name: project_name)).run
    end

    desc "start", "start codebuild project."
    long_desc Help.text(:start)
    option :source_version, default: "master", desc: "git branch"
    option :branch, aliases: "b", default: "master", desc: "git branch"
    option :env_vars, type: :array, desc: "env var overrides. IE: KEY1=VALUE1 KEY2=VALUE2"
    common_options.call
    def start(project_name=nil)
      Start.new(options.merge(project_name: project_name)).run
    end

    desc "status", "status of codebuild project."
    long_desc Help.text(:status)
    option :build_id, desc: "Project build id. Defaults to most recent."
    common_options.call
    def status(project_name=nil)
      Status.new(options.merge(project_name: project_name)).run
    end

    desc "stop", "stop codebuild project."
    long_desc Help.text(:stop)
    option :build_id, desc: "Project build id. Defaults to most recent."
    common_options.call
    def stop(project_name=nil)
      Stop.new(options.merge(project_name: project_name)).run
    end

    desc "list", "list codebuild project."
    long_desc Help.text(:list)
    def list
      List.new(options).run
    end

    desc "logs", "Prints out logs for codebuild project."
    long_desc Help.text(:logs)
    option :build_id, desc: "Project build id. Defaults to most recent."
    option :since, desc: "From what time to begin displaying logs.  By default, logs will be displayed starting from 7 days in the past. The value provided can be an ISO 8601 timestamp or a relative time."
    common_options.call
    def logs(project_name=nil)
      Logs.new(options.merge(project_name: project_name)).run
    end

    desc "completion *PARAMS", "Prints words for auto-completion."
    long_desc Help.text(:completion)
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generates a script that can be eval to setup auto-completion."
    long_desc Help.text(:completion_script)
    def completion_script
      Completer::Script.generate
    end

    desc "version", "prints version"
    def version
      puts VERSION
    end
  end
end
