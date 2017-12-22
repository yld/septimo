# frozen_string_literal: true

if defined? Devise
  RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, type: :controller if defined?(Devise)
  end
end
