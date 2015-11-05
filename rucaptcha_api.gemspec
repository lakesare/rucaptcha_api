# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rucaptcha_api/version'

Gem::Specification.new do |spec|
  spec.name          = "rucaptcha_api"
  spec.version       = RucaptchaApi::VERSION
  spec.authors       = ["Jevgenija Karunus"]
  spec.email         = ["lakesare@gmail.com"]

  spec.summary       = 'Ruby mapper for https://rucaptcha.com API'
  spec.homepage      = 'https://github.com/lakesare/rucaptcha_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency 'rest-client'
  spec.add_runtime_dependency 'nokogiri'

end
