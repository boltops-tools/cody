require "aws-sdk-codebuild"
require "aws-sdk-cloudformation"

module Cody
  module AwsServices
    include Helpers

    def codebuild
      @codebuild ||= Aws::CodeBuild::Client.new
    end

    def cfn
      @cfn ||= Aws::CloudFormation::Client.new
    end
  end
end