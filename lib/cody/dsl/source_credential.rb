module Cody::Dsl
  module SourceCredential
    PROPERTIES = %w[
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

    def auth_type(value)
      @auth_type = value.upcase
    end

    def server_type(value)
      @server_type = value.upcase
    end
  end
end
