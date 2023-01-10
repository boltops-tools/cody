$:.unshift(File.expand_path("../", __FILE__))
require "active_support"
require "active_support/core_ext/string"
require "aws_data"
require "cfn_camelizer"
require "cfn_status"
require "cody/version"
require "dsl_evaluator"
require "memoist"
require "rainbow/ext/string"
require "yaml"

require "cody/autoloader"
Cody::Autoloader.setup

module Cody
  DEFAULT_IMAGE = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  class Error < StandardError; end
  class DeprecationError < StandardError; end
  extend Core
end
