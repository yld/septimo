require 'factory_girl'

FactoryGirl.find_definitions <% if options['zeus'] -%>unless zeus_running? <% end %>

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

