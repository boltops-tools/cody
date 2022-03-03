class Cody::Stack
  module Status
    def status
      @status ||= CfnStatus.new(@stack_name)
    end
  end
end
