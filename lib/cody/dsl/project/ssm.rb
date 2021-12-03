require "aws-sdk-ssm"

module Cody::Dsl::Project
  module Ssm
    # This method grabs the ssm parameter store value at "compile" time vs
    # CloudFormation run time. In case we need it as part of the DSL compile phase.
    def ssm(name)
      resp = ssm_client.get_parameter(name: name)
      if resp.parameter.type == "SecureString"
        resp = ssm_client.get_parameter(name: name, with_decryption: true)
      end

      resp.parameter.value
    rescue Aws::SSM::Errors::ParameterNotFound
      puts "WARN: #{name} not found on AWS SSM.".color(:yellow)
    end

    def ssm_client
      @ssm_client ||= Aws::SSM::Client.new
    end
  end
end