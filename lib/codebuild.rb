$:.unshift(File.expand_path("../", __FILE__))
require "aws-sdk-codebuild"
require "cfn_camelizer"
require "codebuild/version"
require "rainbow/ext/string"

module Codebuild
  class Error < StandardError; end

  autoload :CLI, "codebuild/cli"
  autoload :Command, "codebuild/command"
  autoload :Completer, "codebuild/completer"
  autoload :Completion, "codebuild/completion"
  autoload :Help, "codebuild/help"
  autoload :Init, "codebuild/init"
  autoload :Sequence, "codebuild/sequence"
  autoload :Dsl, "codebuild/dsl"
  autoload :Create, "codebuild/create"
  autoload :Project, "codebuild/project"
  autoload :Role, "codebuild/role"
  autoload :Evaluate, "codebuild/evaluate"
  autoload :Stack, "codebuild/stack"
  autoload :Update, "codebuild/update"
  autoload :Deploy, "codebuild/deploy"
end
