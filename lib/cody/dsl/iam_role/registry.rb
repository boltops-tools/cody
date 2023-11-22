require "set"

module Cody::Dsl::IamRole
  class Registry
    class_attribute :iam_statements
    self.iam_statements = nil # nil to allow fallback to default_iam_statements in cody/iam_role.rb
    class_attribute :managed_policy_arns
    self.managed_policy_arns = nil # nil to allow fallback to default_managed_policy_arns in cody/iam_role.rb

    class << self
      def register_policy(*statements)
        statements.flatten!
        self.iam_statements ||= []
        self.iam_statements += statements # using set so DSL can safely be evaluated multiple times
      end

      def register_managed_policy(*policies)
        policies.flatten!
        self.managed_policy_arns ||= []
        self.managed_policy_arns += policies # using set so DSL can safely be evaluated multiple times
        self.managed_policy_arns.uniq!
      end
    end
  end
end
