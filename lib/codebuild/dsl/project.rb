module Codebuild::Dsl
  module Project
    PROPERTIES = %w[
      artifacts
      badge_enabled
      cache
      description
      encryption_key
      environment
      logs_config
      name
      queued_timeout_in_minutes
      secondary_artifacts
      secondary_sources:
      service_role
      source
      tags
      timeout_in_minutes
      triggers
      vpc_config
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
        @properties[prop.to_sym] = v
      end
    end
  end
end
