module Cody::Dsl::Project
  module Git
    # Convenience wrapper methods
    def branch(branch_or_tag)
      @properties[:SourceVersion] = branch_or_tag
    end
    alias_method :git_branch, :branch

    # source: org/repo
    def github(source)
      # Change to https format that CodeBuild requires if use accidentally provides incorrect form
      source.sub!('git@github.com:', 'https://github.com/')
      source = "https://github.com/#{source}" unless source.include?('http')
      git(source) # source has been transformed to url
    end

    # Convenience wrapper methods
    def git(url)
      url.sub!('.git','')
      @properties[:Source][:Location] = url
    end
    alias_method :source_url, :git

    # Convenience wrapper methods
    def source_type(type="GITHUB")
      @properties[:Source][:Type] = type
    end

    # So it looks like the auth resource property doesnt really get used.
    # Instead an account level credential is worked.  Refer to:
    # https://github.com/tongueroo/cody/blob/master/readme/github_oauth.md
    #
    # Keeping this method around in case the CloudFormation method works one day,
    # or end up figuring out to use it properly.
    def source_auth_resource(token)
      @properties[:Source][:Auth][:Resource] = token
    end

    def github_source(options={})
      source = {
        Type: options[:Type] || "GITHUB",
        Location: options[:Location],
        GitCloneDepth: 1,
        GitSubmodulesConfig: { fetch_submodules: true },
        BuildSpec: options[:BuildSpec] || ".cody/buildspec.yml", # options[:Buildspec] accounts for type already
      }

      if source[:Type] =~ /GITHUB/
        source[:ReportBuildStatus] = true
      end

      if options[:OauthToken]
        source[:Auth] = {
          Type: "OAUTH",
          Resource: options[:OauthToken],
        }
      end

      @properties[:Source] = source
    end
  end
end
