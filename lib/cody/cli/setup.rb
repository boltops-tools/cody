class Cody::CLI
  class Setup < Sequence
    def self.cli_options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:name, desc: "CodeBuild project name"],
        [:mode, default: "light", desc: "Modes: light or full"],
        [:template, desc: "Custom template to use"],
        [:template_mode, desc: "Template mode: replace or additive"],
        [:type, desc: "Type option creates a subfolder under .cody"],
      ]
    end
    cli_options.each { |o| class_option(*o) }

    def setup_template_repo
      return unless @options[:template]&.include?('/')

      sync_template_repo
    end

    def set_source_path
      return unless @options[:template]

      custom_template = "#{ENV['HOME']}/.cody/templates/#{full_repo_name}"

      if @options[:template_mode] == "replace" # replace the template entirely
        override_source_paths(custom_template)
      else # additive: modify on top of default template
        default_template = File.expand_path("../../template", __FILE__)
        override_source_paths([custom_template, default_template])
      end
    end

    def copy_top_level
      dest = ".cody"
      excludes = %w[.git]
      if @options[:mode] == "light"
        excludes += %w[
          settings.yml
          variables
        ]
      end
      pattern = Regexp.new(excludes.join('|'))
      directory "top", dest, exclude_pattern: pattern
    end

    def copy_project
      dest = ".cody"
      dest = "#{dest}/#{@options[:type]}" if @options[:type]

      excludes = %w[.git]
      if @options[:mode] == "light"
        excludes += %w[
          role.rb
          schedule.rb
        ]
      end

      pattern = Regexp.new(excludes.join('|'))
      directory "project", dest, exclude_pattern: pattern
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

    def lookup_managed_image(pattern=/amazonlinux2-x86_64-standard/)
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
      # IE: aws/codebuild/amazonlinux2-x86_64-standard:2.0
      # Falls back to hard-coded image name since the API changed and looks like it's returning no ruby images
      latest_version = versions.sort.last
      if latest_version
        # Drop the "date part"
        # aws/codebuild/amazonlinux2-x86_64-standard:2.0-19.11.26 ->
        # aws/codebuild/amazonlinux2-x86_64-standard:2.0 ->
        latest_version.split('-')[0..-2].join('-')
      else
        fallback_image
      end
    end

    def fallback_image
      "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    end
  end
end