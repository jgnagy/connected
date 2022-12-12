# frozen_string_literal: true

require_relative "lib/connected/version"

Gem::Specification.new do |spec|
  spec.name          = "connected"
  spec.version       = Connected::VERSION
  spec.authors       = ["Jonathan Gnagy"]
  spec.email         = ["jonathan.gnagy@gmail.com"]

  spec.summary       = "A shortest path first gem"
  spec.description   = "A Ruby object-oriented search library for directed and undirected " \
                       "graphs based loosely on Dijkstra's algorithm"
  spec.homepage      = "https://github.com/jgnagy/connected"

  spec.license       = "MIT"
  spec.required_ruby_version = "~> 3.1"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", "~> 13"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rubocop", "~> 1.40"
  spec.add_development_dependency "rubocop-rake",        "~> 0.6"
  spec.add_development_dependency "rubocop-rspec",       "~> 2.11"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "simplecov-cobertura", "~> 2.1"
  spec.add_development_dependency "solargraph",          "~> 0.45"
  spec.add_development_dependency "yard", "~> 0.9"
end
