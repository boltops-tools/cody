require "thor"

# Override thor's long_desc identation behavior
# https://github.com/erikhuda/thor/issues/398
class Thor
  module Shell
    class Basic
      def print_wrapped(message, options = {})
        message = "\n#{message}" unless message[0] == "\n"
        stdout.puts message
      end
    end
  end
end

# Gets rid of the c_l_i extra commands in the help menu. Seems like thor_classes_in is only used
# for this purpose. More details: https://gist.github.com/tongueroo/ee92ec28a4d3eed301d88e8ccdd2fe10
module ThorPrepend
  module Util
    def thor_classes_in(klass)
      klass.name.include?("CLI") ? [] : super
    end
  end
end
Thor::Util.singleton_class.prepend(ThorPrepend::Util)

module Cody
  class Command < Thor
    class << self
      def dispatch(m, args, options, config)
        check_project!(args)

        # Allow calling for help via:
        #   cody command help
        #   cody command -h
        #   cody command --help
        #   cody command -D
        #
        # as well thor's normal way:
        #
        #   cody help command
        help_flags = Thor::HELP_MAPPINGS + ["help"]
        if args.length > 1 && !(args & help_flags).empty?
          args -= help_flags
          args.insert(-2, "help")
        end

        #   cody version
        #   cody --version
        #   cody -v
        version_flags = ["--version", "-v"]
        if args.length == 1 && !(args & version_flags).empty?
          args = ["version"]
        end

        super
      end

      def help_flags
        Thor::HELP_MAPPINGS + ["help"]
      end
      private :help_flags

      def subcommand?
        !!caller.detect { |l| l.include?('in subcommand') }
      end

      def check_project!(args)
        command_name = args.first
        return if subcommand?
        return if command_name.nil?
        return if help_flags.include?(args.last) # IE: -h help
        return if %w[-h -v --version central init setup start version].include?(command_name)
        return if File.exist?("#{Cody.root}/.cody")

        logger.error "ERROR: It doesnt look like this project has cody set up.".color(:red)
        logger.error "Are you sure you are in a project with .cody files?".color(:red)
        ENV['CODY_TEST'] ? raise : exit(1)
      end

      # Override command_help to include the description at the top of the
      # long_description.
      def command_help(shell, command_name)
        meth = normalize_command_name(command_name)
        command = all_commands[meth]
        alter_command_description(command)
        super
      end

      def alter_command_description(command)
        return unless command

        # Add description to beginning of long_description
        long_desc = if command.long_description
            "#{command.description}\n\n#{command.long_description}"
          else
            command.description
          end

        # add reference url to end of the long_description
        unless website.empty?
          full_command = [command.ancestor_name, command.name].compact.join('-')
          url = "#{website}/reference/codebuild-#{full_command}"
          long_desc += "\n\nHelp also available at: #{url}"
        end

        command.long_description = long_desc
      end
      private :alter_command_description

      # meant to be overriden
      def website
        ""
      end

      # https://github.com/erikhuda/thor/issues/244
      # Deprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `Lono::CLI`
      # You can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.
      def exit_on_failure?
        true
      end
    end
  end
end
