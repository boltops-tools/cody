module Cody::Dsl
  module IamRole
    extend Memoist

    PROPERTIES = %w[
      AssumeRolePolicyDocument
      ManagedPolicyArns
      MaxSessionDuration
      Path
      PermissionsBoundary
      Policies
      RoleName
    ]
    PROPERTIES.each do |prop|
      define_method(prop.underscore) do |v|
        @properties[prop.to_sym] = v
      end
    end

    # convenience wrapper methods
    def iam_policy(*definitions)
      statements = definitions.map { |definition| standardize_iam_policy(definition) }
      Registry.register_policy(statements)
    end

    def managed_iam_policy(*definitions)
      managed_policy_arns = definitions.map { |definition| standardize_managed_iam_policy(definition) }
      Registry.register_managed_policy(managed_policy_arns)
    end

    # Returns standarized IAM statement
    def standardize_iam_policy(definition)
      case definition
      when String
        # Expands simple string from: logs => logs:*
        definition = "#{definition}:*" unless definition.include?(':')
        {
          Action: [definition],
          Effect: "Allow",
          Resource: "*",
        }
      when Hash
        definition
      end
    end

    # AmazonEC2ReadOnlyAccess => arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
    def standardize_managed_iam_policy(definition)
      return definition if definition.include?('iam::aws:policy')
      "arn:aws:iam::aws:policy/#{definition}"
    end

    def aws
      AwsData.new
    end
    memoize :aws
  end
end
