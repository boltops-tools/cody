class Cody::CLI
  class Deploy < Base
    def run
      Cody::Stack.new(@options).run
    end
  end
end
