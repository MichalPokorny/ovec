# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ovec/version'

Gem::Specification.new do |spec|
  spec.name          = "ovec"
  spec.version       = Ovec::VERSION
  spec.authors       = ["Michal Pokorný"]
  spec.email         = ["pok@rny.cz"]
  spec.description   = %q{A TeX linter for the Czech language.}
  spec.summary       = %q{Ovec inserts nonbreakable spaces into your Czech language TeX files.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

	spec.required_ruby_version = ">= 2"
end
