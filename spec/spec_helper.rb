ENV["CODY_TEST"] = "1"

# CodeClimate test coverage: https://docs.codeclimate.com/docs/configuring-test-coverage
# require 'simplecov'
# SimpleCov.start

# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentails
ENV['HOME'] = File.join(Dir.pwd,'spec/fixtures/home')

ENV['CODY_ROOT'] = "spec/fixtures/app"


require "pp"
require "byebug"
root = File.expand_path("../", File.dirname(__FILE__))
require "#{root}/lib/cody"

module Helper
  def execute(cmd)
    puts "Running: #{cmd}" if show_command?
    out = `#{cmd}`
    puts out if show_command?
    out
  end

  # Added SHOW_COMMAND because DEBUG is also used by other libraries like
  # bundler and it shows its internal debugging logging also.
  def show_command?
    ENV['DEBUG'] || ENV['SHOW_COMMAND']
  end

  def mock_response(file, build_complete: true)
    data = JSON.load(IO.read(file))

    builds = data["builds"].map do |b|
      phases = b["phases"].map do |phase|
        Aws::CodeBuild::Types::BuildPhase.new(
          phase_type: phase["phase_type"],
          phase_status: phase["phase_status"],
          start_time: phase["start_time"],
          end_time: phase["end_time"],
          duration_in_seconds: phase["duration_in_seconds"],
        )
      end
      logs = Aws::CodeBuild::Types::LogsLocation.new(
        group_name: b["logs"]["group_name"],
        stream_name: b["logs"]["stream_name"],
        cloud_watch_logs_arn: b["logs"]["cloud_watch_logs_arn"],
      )

      Aws::CodeBuild::Types::Build.new(
        build_complete: build_complete,
        logs: logs,
        phases: phases,
      )
    end
    Aws::CodeBuild::Types::BatchGetBuildsOutput.new(builds: builds)
  end
end

RSpec.configure do |c|
  c.include Helper
end
