require "aws-sdk-ssm"

module Codebuild::Dsl::Project
  module Ssm
    def ssm(name)
      resp = ssm_client.get_parameter(name: name)
      if resp.parameter.type == "SecureString"
        resp = ssm_client.get_parameter(name: name, with_decryption: true)
      end

      resp.parameter.value
    rescue Aws::SSM::Errors::ParameterNotFound
      puts "WARN: #{name} found on AWS SSM.".color(:yellow)
    end

    def ssm_client
      @ssm_client ||= Aws::SSM::Client.new
    end
  end
end