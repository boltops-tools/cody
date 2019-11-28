describe Cody::Logs do
  context "first call before cloudwatch log group name is set" do
    let(:logs) do
      logs = Cody::Logs.new({}, :fake_build_id)
      allow(logs).to receive(:codebuild).and_return(codebuild)
      logs
    end
    let(:codebuild) do
      client = double(:codebuild).as_null_object
      allow(client).to receive(:batch_get_builds).and_return(*batch_get_builds_response)
      client
    end
    let(:batch_get_builds_response) do
      [ mock_response("spec/fixtures/aws_responses/build-1.json") ]
    end

    it "prints out build phases" do
      logs.tail
      expect(logs.output).to include("Phase Details")
    end
  end
end
