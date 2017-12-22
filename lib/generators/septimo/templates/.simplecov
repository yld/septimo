require 'simplecov-json'
require 'simplecov-cobertura'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::CoberturaFormatter
]

SimpleCov.start 'rails' do
  coverage_dir('tmp/coverage')
  # any custom configs like groups and filters can be here at a central place
  add_filter '/test/'
  add_filter 'custom_plan.rb'
  add_group 'Channels', 'app/channels'
  add_group 'Helpers', 'app/helpers'
  add_group 'Concerns', 'app/concerns'
  add_group 'Controllers concerns', 'app/controllers/concerns'
  add_group 'Controllers', 'app/controllers'
  add_group 'Decorators', 'app/decorators'
  add_group 'Jobs', 'app/jobs'
  add_group 'Libraries', 'lib'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
end
