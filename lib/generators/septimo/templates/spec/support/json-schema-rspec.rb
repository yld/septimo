require 'json-schema-rspec'

RSpec.configure do |config|
  config.include JSON::SchemaMatchers
end
