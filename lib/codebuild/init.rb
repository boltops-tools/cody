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

    def copy_project
      puts "Initialize codebuild project in .codebuild"
      directory "."
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
  end
end