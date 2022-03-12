class Cody::Builder
  class SourceCredential < Cody::Dsl::Base
    include Cody::Dsl::SourceCredential

    def initialize(options={})
      super
      @source_credentials_path = lookup_cody_file("source_credentials.rb")
    end

    def build
      return unless File.exist?(@source_credentials_path)

      old_properties = @properties.clone
      load_variables
      evaluate_file(@source_credentials_path)

      @properties[:Token] = @token if @token
      return if old_properties == @properties # empty source_credentials.rb file

      resource = {
        SourceCredential: {
          Type: "AWS::CodeBuild::SourceCredential",
          Properties: @properties
        }
      }
      auto_camelize(resource)
    end

    def default_properties
      {
        AuthType: @auth_type || "PERSONAL_ACCESS_TOKEN",
        ServerType: @server_type || "GITHUB",
      }
    end
  end
end
