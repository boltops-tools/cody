class Cody::Builder
  class Schedule < Cody::Dsl::Base
    include Cody::AwsServices::Concerns
    include Cody::Dsl::Schedule

    def initialize(options={})
      super
      @schedule_path = lookup_cody_file("schedule.rb")
      @iam_policy = {}
    end

    def build
      return unless File.exist?(@schedule_path)

      old_properties = @properties.clone
      load_variables
      evaluate_file(@schedule_path)

      @properties[:ScheduleExpression] = @schedule_expression if @schedule_expression
      set_rule_event! if @rule_event_props
      return if old_properties == @properties # empty schedule.rb file

      resource = {
        EventsRule: {
          Type: "AWS::Events::Rule",
          Properties: @properties
        },
        EventsRuleRole: events_rule_role,
      }
      auto_camelize(resource)
    end

    def set_rule_event!
      props = @rule_event_props
      if props.key?(:Detail)
        description = props.key?(:Description) ? props.delete(:Description) : rule_description
        rule_props = { EventPattern: props, description: description }
      else # if props.key?(:EventPattern)
        props[:Description] ||= rule_description
        rule_props = props
      end

      @properties.merge!(rule_props)
    end

    def default_properties
      description = "Cody #{@options[:full_project_name]}"
      name = description.gsub(" ", "-").downcase
      {
        Description: "#{description} CodeBuild project",
        # EventPattern: ,
        Name: name,
        # ScheduleExpression: ,
        State: "ENABLED",
        Targets: [{
          Arn: { "Fn::GetAtt": "CodeBuild.Arn" },
          RoleArn: { "Fn::GetAtt": "EventsRuleRole.Arn" }, # required for specific CodeBuild target.
          Id: "CodeBuildTarget",
        }]
      }
    end

  private
    def events_rule_role
      text =<<~EOL
        AssumeRolePolicyDocument:
          Statement:
          - Action:
            - sts:AssumeRole
            Effect: Allow
            Principal:
              Service:
              - events.amazonaws.com
          Version: '2012-10-17'
        Path: "/"
        Policies:
        - PolicyName: CodeBuildAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Action: codebuild:StartBuild
              Effect: Allow
              Resource: arn:aws:codebuild:#{aws_region}:#{aws_account}:project/#{@options[:full_project_name]}
        # So Amazon EventsBridge / Rules / Monitoring Tab can report Invocations and TriggeredRules
        - PolicyName: CloudWatchAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Action: cloudwatch:*
              Effect: Allow
              Resource: '*'
      EOL
      props = YAML.load(text)

      {
        Type: "AWS::IAM::Role",
        Properties: props
      }
    end
  end
end
