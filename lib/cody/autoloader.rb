require "zeitwerk"

module Cody
  class Autoloader
    class Inflector < Zeitwerk::Inflector
      def camelize(basename, _abspath)
        map = { cli: "CLI", version: "VERSION" }
        map[basename.to_sym] || super
      end
    end

    class << self
      def setup
        loader = Zeitwerk::Loader.new
        loader.inflector = Inflector.new
        lib = File.dirname(__dir__) # lib
        loader.push_dir(lib)
        loader.do_not_eager_load("#{lib}/template")
        loader.log!
        loader.setup
      end
    end
  end
end
