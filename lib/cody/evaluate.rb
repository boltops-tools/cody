module Cody
  module Evaluate
    include DslEvaluator
    include Interface

    def lookup_cody_file(name)
      [".cody", @options[:type], name].compact.join("/")
    end
  end
end
