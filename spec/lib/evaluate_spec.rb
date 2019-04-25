describe Codebuild::Evaluate do
  let(:evaluate) do
    Codebuild::Evaluate.new(project_path: "spec/fixtures/codebuild/project.rb")
  end
  context "general" do
    it "builds up the template in memory" do
      template = evaluate.run
      expect(template).to eq({:name=>"test-codebuild-project", :description=>"test desc"})
    end
  end
end
