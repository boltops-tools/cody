# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cody/version"

Gem::Specification.new do |spec|
  spec.name          = "cody"
  spec.version       = Cody::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.summary       = "Cody provides a beautiful DSL to create and manage AWS CodeBuild projects"
  spec.homepage      = "https://github.com/tongueroo/cody"
  spec.license       = "MIT"

  vendor_files       = Dir.glob("vendor/**/*")
  gem_files          = `git -C "#{File.dirname(__FILE__)}" ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|docs)/})
  end
  spec.files         = gem_files + vendor_files
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 6.0.0"
  spec.add_dependency "aws-logs"
  spec.add_dependency "aws-mfa-secure"
  spec.add_dependency "aws-sdk-cloudformation"
  spec.add_dependency "aws-sdk-codebuild"
  spec.add_dependency "aws-sdk-ssm"
  spec.add_dependency "memoist"
  spec.add_dependency "rainbow"
  spec.add_dependency "render_me_pretty"
  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"

  # spec.add_dependency "aws_data" # using vendor/cfn_camelizer for now
  # spec.add_dependency "cfn_camelizer" # using vendor/cfn_camelizer for now

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "cli_markdown"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
