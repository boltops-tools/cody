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

    def run
      return unless File.exist?(@schedule_path)

      old_properties = @properties.clone
      load_variables
      evaluate(@schedule_path)

      @properties[:schedule_expression] = @schedule_expression if @schedule_expression
      set_rule_event! if @rule_event_props
      return if old_properties == @properties # empty schedule.rb file

      resource = {
        events_rule: {
          type: "AWS::Events::Rule",
          properties: @properties
        },
        events_rule_role: events_rule_role,
      }
      CfnCamelizer.transform(resource)
    end

    def set_rule_event!
      props = @rule_event_props
      if props.key?(:detail)
        description = props.key?(:description) ? props.delete(:description) : rule_description
        rule_props = { event_pattern: props, description: description }
      else # if props.key?(:event_pattern)
        props[:description] ||= rule_description
        rule_props = props
      end

      @properties.merge!(rule_props)
    end

    def default_properties
      description = "Cody #{@options[:full_project_name]}"
      name = description.gsub(" ", "-").downcase
      {
        description: "#{description} CodeBuild project",
        # event_pattern: ,
        name: name,
        # schedule_expression: ,
        state: "ENABLED",
        targets: [{
          arn: { "Fn::GetAtt": "CodeBuild.Arn" },
          role_arn: { "Fn::GetAtt": "EventsRuleRole.Arn" }, # required for specific CodeBuild target.
          id: "CodeBuildTarget",
        }]
      }
    end

  private
    def get_schedule_path
      lookup_cody_file("schedule.rb")
    end

    def events_rule_role
      {
        type: "AWS::IAM::Role",
        properties: {
          assume_role_policy_document: {
            statement: [{
              action: [ "sts:AssumeRole" ],
              effect: "Allow",
              principal: { service: [ "events.amazonaws.com" ] }
            }],
            version: "2012-10-17"
          },
          path: "/",
          policies: [{
            policy_name: "CodeBuildAccess",
            policy_document: {
              version: "2012-10-17",
              statement: [{
                action: "codebuild:StartBuild",
                effect: "Allow",
                resource: "arn:aws:codebuild:#{aws_data.region}:#{aws_data.account}:project/#{@options[:full_project_name]}"
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
