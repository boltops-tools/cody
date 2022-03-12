module Cody
  class Schedule < Dsl::Base
    include Cody::Dsl::Schedule
    include Evaluate
    include Variables

    def initialize(options={})
      super
      @schedule_path = options[:schedule_path] || get_schedule_path
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
    def get_schedule_path
      lookup_cody_file("schedule.rb")
    end

    def events_rule_role
      {
        Type: "AWS::IAM::Role",
        Properties: {
          AssumeRolePolicyDocument: {
            Statement: [{
              Action: [ "sts:AssumeRole" ],
              Effect: "Allow",
              Principal: { Service: [ "events.amazonaws.com" ] }
            }],
            Version: "2012-10-17"
          },
          Path: "/",
          Policies: [{
            PolicyName: "CodeBuildAccess",
            PolicyDocument: {
              Version: "2012-10-17",
              Statement: [{
                Action: "codebuild:StartBuild",
                Effect: "Allow",
                Resource: "arn:aws:codebuild:#{aws_data.region}:#{aws_data.account}:project/#{@options[:full_project_name]}"
              }]
            }
          }]
        }
      }
    end

    def aws_data
      @aws_data ||= AwsData.new
    end
  end
end
