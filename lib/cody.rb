$:.unshift(File.expand_path("../", __FILE__))
require "aws_data"
require "cfn_camelizer"
require "cfn_status"
require "cody/version"
require "memoist"
require "rainbow/ext/string"
require "yaml"

require "cody/autoloader"
Cody::Autoloader.setup

module Cody
  class Error < StandardError; end
  extend Core
end

Cody.set_aws_profile!
