$:.unshift(File.expand_path("../", __FILE__))
require "codebuild/version"
require "rainbow/ext/string"
require "yaml"

require "codebuild/autoloader"
Codebuild::Autoloader.setup

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/vendor/aws_data/lib")
require "aws_data"
$:.unshift("#{gem_root}/vendor/cfn_camelizer/lib")
require "cfn_camelizer"
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn/status"

module Codebuild
  class Error < StandardError; end
  extend Core
end

Codebuild.set_aws_profile!
