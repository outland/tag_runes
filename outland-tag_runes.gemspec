# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'outland/tag_runes/version'

Gem::Specification.new do |spec|
  spec.name          = "outland-tag_runes"
  spec.version       = Outland::TagRunes::VERSION
  spec.authors       = ["Bill Lipa"]
  spec.email         = ["dojo@masterleep.com"]

  spec.summary       = %q{Encode Rails session and request id into the log using only 7 columns, via Unicode.}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/outland/tag_runes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
