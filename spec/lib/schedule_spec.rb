describe Cody::Schedule do
  let(:schedule) do
    Cody::Schedule.new(schedule_path: "spec/fixtures/app/.codebuild/schedule.rb")
  end
  context "general" do
    it "builds up the template in memory" do
      template = schedule.run
      expect(template.keys).to eq ["EventsRule", "EventsRuleRole"]
      expect(template["EventsRule"]).to be_a(Hash)
    end
  end
end
