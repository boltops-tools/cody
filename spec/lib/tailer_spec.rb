describe Cody::Tailer do
  context "first call before cloudwatch log group name is set" do
    let(:logs) do
      logs = Cody::Tailer.new({}, :fake_build_id)
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
      logs.run
      expect(logs.output).to include("Phase")
    end
  end

  context "multiple calls to print_phases" do
    let(:logs) do
      Cody::Tailer.new({}, :fake_build_id)
    end

    it "print_phases" do
      build = mock_response("spec/fixtures/aws_responses/build-1.json").builds.first
      logs.print_phases(build)

      build = mock_response("spec/fixtures/aws_responses/build-1.json").builds.first
      logs.print_phases(build)
      expect(logs.output.scan("SUBMITTED").size).to eq 1
    end
  end
end
