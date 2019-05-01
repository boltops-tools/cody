module Codebuild
  class Init < Sequence
    # Ugly, this is how I can get the options from to match with this Thor::Group
    def self.cli_options
      [
        [:name, desc: "CodeBuild project name."],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:template, desc: "Custom template to use."],
        [:template_mode, desc: "Template mode: replace or additive."],
      ]
    end
    cli_options.each { |o| class_option(*o) }

    def setup_template_repo
      return unless @options[:template]&.include?('/')

      sync_template_repo
    end

    def set_source_path
      return unless @options[:template]

      custom_template = "#{ENV['HOME']}/.codebuild/templates/#{full_repo_name}"

      if @options[:template_mode] == "replace" # replace the template entirely
        override_source_paths(custom_template)
      else # additive: modify on top of default template
        default_template = File.expand_path("../../template", __FILE__)
        override_source_paths([custom_template, default_template])
      end
    end

    def copy_project
      puts "Initialize codebuild project in .codebuild"
      if @options[:template]
        directory ".", ".codebuild", exclude_pattern: /.git/
      else
        directory ".", exclude_pattern: /.git/
      end
    end

  private
    def project_name
      inferred_name = File.basename(Dir.pwd).gsub('_','-').gsub(/[^0-9a-zA-Z,-]/, '')
      @options[:name] || inferred_name
    end

    def project_github_url
      default = "https://github.com/user/repo"
      return default unless File.exist?(".git/config") && git_installed?

      url = `git config --get remote.origin.url`.strip
      url = url.sub('git@github.com:','https://github.com/')
      url == '' ? default : url
    end

    def lookup_managed_image(pattern=/ruby:/)
      resp = codebuild.list_curated_environment_images

      # Helpful for debugging:
      #   aws codebuild list-curated-environment-images | jq -r '.platforms[].languages[].images[].versions[]' | sort

      versions = []
      resp.platforms.each do |platform|
        platform.languages.each do |lang|
          lang.images.each do |image|
            versions += image.versions.compact
          end
        end
      end
      versions = versions.select { |v| v =~ pattern }
      versions.sort.last # IE: aws/codebuild/ruby:2.5.3-1.7.0
    end
  end
end