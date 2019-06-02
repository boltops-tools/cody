module Codebuild
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "init", "Initialize project with .codebuild files"
    long_desc Help.text(:init)
    Init.cli_options.each do |args|
      option(*args)
    end
    register(Init, "init", "init", "Set up initial ufo files.")

    desc "evaluate", "Evaluate the .codebuild/project.rb DSL."
    long_desc Help.text(:evaluate)
    def evaluate
      Dsl.new(options).evaluate
    end

    lookup_option = Proc.new do
      option :lookup, desc: "folder to use within .codebuild folder for extra lookups of files"
    end

    desc "create", "Create codebuild project."
    long_desc Help.text(:create)
    lookup_option.call
    def create(stack_name=nil)
      Create.new(options.merge(stack_name: stack_name)).run
    end

    desc "update", "Update codebuild project."
    long_desc Help.text(:update)
    lookup_option.call
    def update(stack_name=nil)
      Update.new(options.merge(stack_name: stack_name)).run
    end

    desc "deploy", "Deploy codebuild project."
    long_desc Help.text(:deploy)
    lookup_option.call
    def deploy(stack_name=nil)
      Deploy.new(options.merge(stack_name: stack_name)).run
    end

    desc "delete", "Delete codebuild project."
    long_desc Help.text(:delete)
    option :sure, desc: "Bypass are you sure prompt"
    lookup_option.call
    def delete(stack_name=nil)
      Delete.new(options.merge(stack_name: stack_name)).run
    end

    desc "start", "start codebuild project."
    long_desc Help.text(:start)
    option :source_version, default: "master", desc: "git branch"
    option :branch, aliases: "b", default: "master", desc: "git branch"
    lookup_option.call
    def start(identifier=nil)
      Start.new(options.merge(identifier: identifier)).run
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
