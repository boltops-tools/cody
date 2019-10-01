require 'fileutils'
require 'thor'

module Cody
  class Sequence < Thor::Group
    include AwsServices
    include Thor::Actions

    add_runtime_options! # force, pretend, quiet, skip options
      # https://github.com/erikhuda/thor/blob/master/lib/thor/actions.rb#L49

    def self.source_paths
      [File.expand_path("../../template", __FILE__)]
    end

  private
    def override_source_paths(*paths)
      # Using string with instance_eval because block doesnt have access to
      # path at runtime.
      self.class.instance_eval %{
        def self.source_paths
          #{paths.flatten.inspect}
        end
      }
    end

    def sync_template_repo
      unless git_installed?
        abort "Unable to detect git installation on your system.  Git needs to be installed in order to use the --template option."
      end

      template_path = "#{ENV['HOME']}/.cody/templates/#{full_repo_name}"
      if File.exist?(template_path)
        sh("cd #{template_path} && git pull")
      else
        FileUtils.mkdir_p(File.dirname(template_path))
        sh("git clone #{repo_url} #{template_path}")
      end
    end

    def full_repo_name
      full_repo = options[:template].split("/")[-2..-1].join("/")
      full_repo = full_repo.split(":").last
      full_repo.sub(".git", "")
    end

    # normalize repo_url
    def repo_url
      template = options[:template]
      if template.include?('github.com')
        template # leave as is, user has provided full github url
      else
        "https://github.com/#{template}"
      end
    end

    def git_installed?
      system("type git > /dev/null")
    end

    def sh(command)
      puts "=> #{command}"
      system(command)
    end
  end
end
