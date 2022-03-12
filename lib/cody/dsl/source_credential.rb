module Cody::Dsl
  module SourceCredential
    PROPERTIES = %w[
      AuthType
      ServerType
      Token
      Username
    ]
    PROPERTIES.each do |prop|
      define_method(prop.underscore) do |v|
        @properties[prop.to_sym] = v
      end
    end

    def token(value)
      @token = value
    end
  end
end
