describe Cody::Role do
  let(:role) { Cody::Role.new(role_path: role_path) }
  let(:role_path) { "spec/fixtures/app/.cody/role.rb" }
  subject(:template) { role.run }

  context "general" do
    it "builds up the template in memory" do
      expect(template.keys).to eq ["IamRole"]
      expect(template["IamRole"]).to be_a(Hash)
    end

    it "sets default properties" do
      expect(template["IamRole"]["Properties"]["Path"]).to eq("/")
      expect(template["IamRole"]["Properties"]["AssumeRolePolicyDocument"]).to eq({
        "Statement" => [{
          "Action" => ["sts:AssumeRole"],
          "Effect" => "Allow",
          "Principal" => { "Service" => ["codebuild.amazonaws.com"]
          }
        }],
        "Version" => "2012-10-17"
      })
      expect(template["IamRole"]["Properties"]["ManagedPolicyArns"]).to eq([
        "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"])
    end
  end

  context "empty managed_policy_arns value" do
    let(:role_path) { "spec/fixtures/app/.cody/role_empty_managed_policy_arns.rb" }
    it "sets ManagedPolicyArns to empty" do
      expect(template["IamRole"]["Properties"]["ManagedPolicyArns"]).to eq([])
    end
  end

  context "empty managed_iam_policy" do
    let(:role_path) { "spec/fixtures/app/.cody/role_empty_managed_iam_policy.rb" }
    it "sets default ManagedPolicyArns" do
      expect(template["IamRole"]["Properties"]["ManagedPolicyArns"]).to eq([])
    end
  end

  context "with managed_policy_arns value" do
    let(:role_path) { "spec/fixtures/app/.cody/role_with_managed_policy_arns.rb" }
    it "sets ManagedPolicyArns to value" do
      expect(template["IamRole"]["Properties"]["ManagedPolicyArns"]).to eq([
        "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"])
    end
  end

  context "with managed_iam_policy value" do
    let(:role_path) { "spec/fixtures/app/.cody/role_with_managed_iam_policy.rb" }
    it "sets ManagedPolicyArns to value" do
      expect(template["IamRole"]["Properties"]["ManagedPolicyArns"]).to eq([
        "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"])
    end
  end
end
