module Cody::Dsl
  module Role
    PROPERTIES = %w[
      assume_role_policy_document
      managed_policy_arns
      max_session_duration
      path
      permissions_boundary
      policies
      role_name
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
        @properties[prop.to_sym] = v
      end
    end

    # convenience wrapper methods
    def iam_policy(*definitions)
      @iam_statements = definitions.map { |definition| standardize_iam_policy(definition) }
    end

    # Returns standarized IAM statement
    def standardize_iam_policy(definition)
      case definition
      when String
        # Expands simple string from: logs => logs:*
        definition = "#{definition}:*" unless definition.include?(':')
        {
          action: [definition],
          effect: "Allow",
          resource: "*",
        }
      when Hash
        definition
      end
    end

    def managed_iam_policy(*definitions)
      @managed_policy_arns = definitions.map { |definition| standardize_managed_iam_policy(definition) }
    end

    # AmazonEC2ReadOnlyAccess => arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
    def standardize_managed_iam_policy(definition)
      return definition if definition.include?('iam::aws:policy')

      "arn:aws:iam::aws:policy/#{definition}"
    end
  end
end
