# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exist_client/version'

Gem::Specification.new do |spec|
  spec.name          = "exist_client"
  spec.version       = ExistClient::VERSION
  spec.authors       = ["Matt Wean"]
  spec.email         = ["matt@mattwean.com"]

  spec.summary       = "A client for posting data to Exist.io"
  spec.description   = "A client for posting data to Exist.io"
  spec.homepage      = "https://github.com/mwean/exist_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "cri", "~> 2.10"
  spec.add_dependency "httparty", "~> 0.15"
end
