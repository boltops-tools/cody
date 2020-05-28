module Cody::Dsl
  module Schedule
    PROPERTIES = %w[
      Description
      EventPattern
      Name
      RoleArn
      ScheduleExpression
      State
      Targets
    ]
    PROPERTIES.each do |prop|
      define_method(prop.underscore) do |v|
        @properties[prop.to_sym] = v
      end
    end

    def rate(period)
      @schedule_expression = "rate(#{period})"
    end

    def cron(expression)
      @schedule_expression = "cron(#{expression})"
    end

    def rule_event(props={})
      @rule_event_props = props
    end
  end
end
