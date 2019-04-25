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
  end
end
