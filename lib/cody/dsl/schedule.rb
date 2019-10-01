module Cody::Dsl
  module Schedule
    PROPERTIES = %w[
      description
      event_pattern
      name
      role_arn
      schedule_expression
      state
      targets
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
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
