# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'siilar/version'

Gem::Specification.new do |spec|
  spec.name          = 'siilar'
  spec.version       = Siilar::VERSION
  spec.authors       = ['Mehdi Lahmam']
  spec.email         = ['mehdi@craftsmen.io']

  spec.summary       = 'A Ruby client for the Siilar API'
  spec.description   = 'A Ruby client for the Siilar API'
  spec.homepage      = 'https://github.com/craftsmen/niland-siilar-ruby'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency  'httparty'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
