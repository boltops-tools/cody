describe Codebuild::CLI do
  before(:all) do
    @args = "--noop"
    @old_root = Dir.pwd
    Dir.chdir("spec/fixtures/app")
    @codebuild_bin = "../../../exe/codebuild"
  end
  after(:all) do
    Dir.chdir(@old_root)
  end

  describe "codebuild" do
    it "deploy" do
      out = execute("#{@codebuild_bin} deploy #{@args}")
      expect(out).to include("Generated CloudFormation template")
    end
  end
end
