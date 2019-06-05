$:.unshift(File.expand_path("../", __FILE__))
require "cfn_camelizer"
require "codebuild/version"
require "rainbow/ext/string"

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn/status"

module Codebuild
  class Error < StandardError; end

  autoload :AwsServices, "codebuild/aws_services"
  autoload :CLI, "codebuild/cli"
  autoload :Command, "codebuild/command"
  autoload :Completer, "codebuild/completer"
  autoload :Completion, "codebuild/completion"
  autoload :Create, "codebuild/create"
  autoload :Delete, "codebuild/delete"
  autoload :Deploy, "codebuild/deploy"
  autoload :Dsl, "codebuild/dsl"
  autoload :Evaluate, "codebuild/evaluate"
  autoload :Help, "codebuild/help"
  autoload :Init, "codebuild/init"
  autoload :Project, "codebuild/project"
  autoload :Role, "codebuild/role"
  autoload :Sequence, "codebuild/sequence"
  autoload :Stack, "codebuild/stack"
  autoload :Start, "codebuild/start"
  autoload :Update, "codebuild/update"
end
