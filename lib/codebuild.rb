$:.unshift(File.expand_path("../", __FILE__))
require "cfn_camelizer"
require "codebuild/version"
require "rainbow/ext/string"
require "yaml"

require "codebuild/autoloader"
Codebuild::Autoloader.setup

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn/status"

module Codebuild
  class Error < StandardError; end
end
