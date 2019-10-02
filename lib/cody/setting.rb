require 'yaml'
require 'render_me_pretty'

module Cody
  class Setting
    extend Memoist
    def initialize(check_codebuild_project=true)
      @check_codebuild_project = check_codebuild_project
    end

    # data contains the settings.yml config.  The order or precedence for settings
    # is the project ufo/settings.yml and then the ~/.cody/settings.yml.
    def data
      Cody.check_codebuild_project! if @check_codebuild_project
      return {} unless File.exist?(project_settings_path)

      # project based settings files
      project = load_file(project_settings_path)

      user_file = "#{ENV['HOME']}/.cody/settings.yml"
      user = File.exist?(user_file) ? YAML.load_file(user_file) : {}

      default_file = File.expand_path("default/settings.yml", __dir__)
      default = load_file(default_file)

      all_envs = default.deep_merge(user.deep_merge(project))
      all_envs = merge_base(all_envs)
      data = all_envs[cb_env] || all_envs["base"] || {}
      data.deep_symbolize_keys
    end
    memoize :data

    # Resolves infinite problem since Cody.env can be determined from CODY_ENV or settings.yml files.
    # When ufo is determined from settings it should not called Cody.env since that in turn calls
    # Settings.new.data which can then cause an infinite loop.
    def cb_env
      path = "#{cb_root}/.cody/settings.yml"
      if File.exist?(path)
        settings = YAML.load_file(path)
        env = settings.find do |_env, section|
          section ||= {}
          ENV['AWS_PROFILE'] && ENV['AWS_PROFILE'] == section['aws_profile']
        end
      end

      cb_env = env.first if env
      cb_env = ENV['CODY_ENV'] if ENV['CODY_ENV'] # highest precedence
      cb_env || 'development'
    end

  private
    def load_file(path)
      return Hash.new({}) unless File.exist?(path)

      content = RenderMePretty.result(path)
      data = YAML.load(content)
      # If key is is accidentally set to nil it screws up the merge_base later.
      # So ensure that all keys with nil value are set to {}
      data.each do |env, _setting|
        data[env] ||= {}
      end
      data
    end

    # automatically add base settings to the rest of the environments
    def merge_base(all_envs)
      base = all_envs["base"] || {}
      all_envs.each do |env, settings|
        all_envs[env] = base.merge(settings) unless env == "base"
      end
      all_envs
    end

    def project_settings_path
      "#{cb_root}/.cody/settings.yml"
    end

    def cb_root
      ENV["CODEBUILD_ROOT"] || Dir.pwd
    end
  end
end
