describe Cody::CLI do
  before(:all) do
    @args = "--noop"
    @codebuild_bin = "exe/codebuild"
  end

  describe "codebuild" do
    it "deploy" do
      out = execute("#{@codebuild_bin} deploy #{@args}")
      expect(out).to include("Generated CloudFormation template")
    end
  end
end
