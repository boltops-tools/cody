module Cody::Dsl
  module SourceCredentials

    PROPERTIES = %w[
      Artifacts
      BadgeEnabled
      Cache
      Description
      EncryptionKey
      Environment
      LogsConfig
      Name
      QueuedTimeoutInMinutes
      SecondaryArtifacts
      SecondarySources
      ServiceRole
      Source
      Tags
      TimeoutInMinutes
      Triggers
      VpcConfig
    ]
    PROPERTIES.each do |prop|
      define_method(prop.underscore) do |v|
        @properties[prop.to_sym] = v
      end
    end

  end
end
