$:.unshift(File.expand_path("../", __FILE__))
require "codebuild/version"
require "rainbow/ext/string"

module Codebuild
  class Error < StandardError; end

  autoload :CLI, "codebuild/cli"
  autoload :Command, "codebuild/command"
  autoload :Completer, "codebuild/completer"
  autoload :Completion, "codebuild/completion"
  autoload :Help, "codebuild/help"
  autoload :Sub, "codebuild/sub"
end
