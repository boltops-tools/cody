describe Cody::CLI do
  before(:all) do
    @args = "--noop"
    @cody_bin = "exe/cody"
  end

  describe "cody" do
    it "deploy" do
      out = execute("#{@cody_bin} deploy #{@args}")
      expect(out).to include("")
    end
  end
end
