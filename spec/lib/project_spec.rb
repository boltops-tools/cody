describe Cody::Project do
  let(:project) do
    Cody::Project.new(project_path: "spec/fixtures/app/.codebuild/project.rb")
  end
  context "general" do
    it "builds up the template in memory" do
      template = project.run
      expect(template.keys).to eq ["CodeBuild"]
      expect(template["CodeBuild"]).to be_a(Hash)
    end
  end
end
