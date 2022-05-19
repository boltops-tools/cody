module Cody::CLI::New
  class Git
    def url
      default = "https://github.com/user/repo"
      return default unless File.exist?(".git/config") && installed?

      url = `git config --get remote.origin.url`.strip
      url = url.sub('git@github.com:','https://github.com/')
      url == '' ? default : url
    end

    # If main branch found assume thats the default. Otherwise, use master
    # Based on https://github.com/LucasLarson/git-default-branch/blob/main/bin/git-default-branch
    def default_branch
      branch = git_symbolic_ref
      return branch if branch
      main_found = system "git branch --list -- 'main' > /dev/null"
      main_found ? "main" : "master"
    end

    def github?
      url.include?('github.com')
    end

    def github_name
      url.split('/')[-2..-1].join('/').sub('.git','')
    end

    # public method used by cody setup
    def installed?
      system("type git > /dev/null")
    end

  private
    def git_symbolic_ref
      git_command = "git symbolic-ref refs/remotes/origin/HEAD"
      success = system("#{git_command} >/dev/null 2>&1")
      return unless success
      out = `#{git_command}` # => refs/remotes/origin/master
      out.split('/').last    # => master
    end
  end
end

