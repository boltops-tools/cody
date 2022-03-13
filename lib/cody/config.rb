require "singleton"

module Cody
  class Config
    extend Memoist
    include DslEvaluator
    include Singleton
    include Cody::Utils::Logging

    # include Cody::TaskDefinition::Helpers

    attr_reader :config
    def initialize
      @config = defaults
    end

    def defaults
      config = ActiveSupport::OrderedOptions.new

      config.cfn = ActiveSupport::OrderedOptions.new
      config.cfn.disable_rollback = nil
      config.cfn.notification_arns = nil
      config.cfn.tags = nil # should be Ruby Hash

      config.log = ActiveSupport::OrderedOptions.new
      config.log.root = Cody.log_root
      config.logger = new_logger
      config.logger.formatter = Logger::Formatter.new
      config.logger.level = ENV['CODY_LOG_LEVEL'] || :info

      config.logs = ActiveSupport::OrderedOptions.new
      config.logs.filter_pattern = nil

      config.names = ActiveSupport::OrderedOptions.new
      config.names.stack = ":APP-:ROLE-:ENV-:EXTRA-cody" # => demo-web-dev
      config.names.task_definition = ":APP-:ROLE-:ENV-:EXTRA" # => demo-web-dev

      # When not set, the default vpc is used
      config.vpc = ActiveSupport::OrderedOptions.new
      config.vpc.id = nil
      config.vpc.security_groups = ActiveSupport::OrderedOptions.new
      config.vpc.security_groups.ids = nil
      config.vpc.security_groups.managed = true
      config.vpc.subnets = nil

      config.auto_camelize = false # so cody doesnt mess up special AWS properties casing
      config.names.append_env = false # true
      config.names.append_stack_name = "cody"

      config
    end

    def new_logger
      Logger.new(ENV['CODY_LOG_PATH'] || $stderr)
    end
    memoize :new_logger

    def configure
      yield(@config)
    end

    # load_project_config gets called so early many things like logger is not available.
    # Take care not to rely on things that rely on the the config or else will create
    # and infinite loop.
    def load_project_config
      root = layer_levels(".cody/config")
      env  = layer_levels(".cody/config/env")
      layers = root + env
      # Dont use Cody.app or that'll cause infinite loop since it loads Cody.config
      if ENV['CODY_APP']
        root = layer_levels(".cody/config/#{Cody.app}")
        env  = layer_levels(".cody/config/#{Cody.app}/env")
        layers += root + env
      end
      # load_project_config gets called so early that logger is not yet configured. use puts
      puts "Config layers:" if ENV['UFO_SHOW_ALL_LAYERS']
      layers.each do |layer|
        path = "#{Cody.root}/#{layer}"
        puts "    #{layer}" if ENV['UFO_SHOW_ALL_LAYERS']
        evaluate_file(path)
      end
    end

    # Works similiar to Layering::Layer. Consider combining the logic and usin Layering::Layer
    #
    # Examples:
    #
    #     prefix: .cody/config/#{Cody.app}/env
    #
    # Returns
    #
    #     .cody/config/#{Cody.app}/env.rb
    #     .cody/config/#{Cody.app}/env/base.rb
    #     .cody/config/#{Cody.app}/env/#{Cody.env}.rb
    #
    def layer_levels(prefix=nil)
      levels = ["", "base", Cody.env]
      paths = levels.map do |i|
        # base layer has prefix of '', reject with blank so it doesnt produce '//'
        [prefix, i].join('/')
      end
      add_ext!(paths)
    end

      def add_ext!(paths)
      ext = "rb"
      paths.map! do |path|
        path = path.sub(/\/$/,'') if path.ends_with?('/')
        "#{path}.rb"
      end
      paths
    end
  end
end
