require 'pathname'
require 'yaml'

module Cody
  module Core
    extend Memoist

    def root
      path = ENV['CODY_ROOT'] || '.'
      Pathname.new(path)
    end

    def env
      env = ENV['CODY_ENV'] || 'dev'
      ActiveSupport::StringInquirer.new(env)
    end
    memoize :env

    def extra
      extra = ENV['CODY_EXTRA'] if ENV['CODY_EXTRA'] # highest precedence
      return if extra&.empty?
      extra
    end
    memoize :extra

    def log_root
      "#{root}/log"
    end

    def configure(&block)
      Config.instance.configure(&block)
    end

    # Checking whether or not the config has been loaded and saving it to @@config_loaded
    # because users can call helper methods in `.ufo/config.rb` files that rely on the config
    # already being loaded. This would produce an infinite loop. The @@config_loaded allows
    # methods to use this info to prevent an infinite loop.
    # Notable methods that use this: Cody.app and Cody.logger
    cattr_accessor :config_loaded
    # In general, use the Cody.config instead of Config.instance.config since it guarantees the load_project_config call
    def config
      Config.instance.load_project_config
      @@config_loaded = true
      Config.instance.config
    end
    memoize :config

    # Allow different logger when running up all or rspec-lono
    cattr_writer :logger
    def logger
      if @@config_loaded
        @@logger = config.logger
      else
        # When .ufo/config.rb is not yet loaded. IE: a helper method like waf
        # gets called in the .ufo/config.rb itself and uses the logger.
        # This avoids an infinite loop. Note: It does create a different Logger
        @@logger ||= Logger.new(ENV['UFO_LOG_PATH'] || $stderr)
      end
    end

  private
    def env_from_profile
      Cody::Setting.new.cb_env
    end
  end
end
