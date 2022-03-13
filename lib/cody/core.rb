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

    def app
      return ENV['CODY_APP'] if ENV['CODY_APP']

      if @@config_loaded
        config.app
      else
        call_line = caller.find {|l| l.include?('.Cody') }
        puts "ERROR: Using Cody.app or :APP expansion very early in the Cody boot process".color(:red)
        puts <<~EOL.color(:red)
          The Cody.app or :APP expansions are not yet available at this point
          You can either:

          1. Use the CODY_APP env var to set it, which allows it to be used.
          2. Hard code your actual app name.

          Called from:

              #{call_line}

        EOL
        exit 1
      end
    end

    def log_root
      "#{root}/log"
    end

    def configure(&block)
      Config.instance.configure(&block)
    end

    # Checking whether or not the config has been loaded and saving it to @@config_loaded
    # because users can call helper methods in `.cody/config.rb` files that rely on the config
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
        # When .cody/config.rb is not yet loaded. IE: a helper method like waf
        # gets called in the .cody/config.rb itself and uses the logger.
        # This avoids an infinite loop. Note: It does create a different Logger
        @@logger ||= Logger.new(ENV['CODY_LOG_PATH'] || $stderr)
      end
    end
  end
end
