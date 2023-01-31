# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "policy_check/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.7.0"

  spec.name          = "policy_check"
  spec.version       = PolicyCheck::VERSION
  spec.authors       = ["HAZI"]
  spec.email         = ["yuhei.mukoyama@gmail.com"]

  spec.summary       = "Create policies for models or policy class"
  spec.homepage      = "https://github.com/hazi/policy_check"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["rubygems_mfa_required"] = "true"
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]
end
