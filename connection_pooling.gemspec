# frozen_string_literal: true

require_relative "lib/connection_pooling/version"

Gem::Specification.new do |spec|
  spec.name = "connection_pooling"
  spec.version = ConnectionPooling::VERSION
  spec.authors = ["Laith"]
  spec.email = ["laythra@gmail.com"]

  spec.summary = "A general purpose connection pooling library"
  spec.description = "A general purpose connection pooling library"
  spec.homepage = "https://jawaker.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  #
  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files  = Dir["CHANGELOG.md", "LICENSE", "README.md", "lib/**/*"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
