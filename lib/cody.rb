$:.unshift(File.expand_path("../", __FILE__))
require "cody/version"
require "rainbow/ext/string"
require "yaml"

require "cody/autoloader"
Cody::Autoloader.setup

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/vendor/aws_data/lib")
require "aws_data"
$:.unshift("#{gem_root}/vendor/cfn_camelizer/lib")
require "cfn_camelizer"
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn/status"
$:.unshift("#{gem_root}/vendor/aws-logs/lib")
require "aws-logs"

module Cody
  class Error < StandardError; end
  extend Core
end

Cody.set_aws_profile!
