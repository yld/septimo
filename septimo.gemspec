# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'septimo/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'septimo'
  s.version     = Septimo::VERSION
  s.authors     = ['Yves Le Douaron']
  s.email       = ['yves.ledouaron@free.fr']
  s.homepage    = 'https://github.com/yld/septimo'
  s.summary     = 'a set of rails generators'
  s.description = 'a set of rails generators'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.4'

  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'listen'
  s.add_development_dependency 'reek'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'rubocop-thread_safety'

  s.add_development_dependency 'sqlite3'
end
