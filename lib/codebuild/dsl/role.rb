module Codebuild::Dsl
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
      @iam_statements = definitions.map { |definition| standardize(definition) }
    end

    # Returns standarized IAM statement
    def standardize(definition)
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

  end
end
