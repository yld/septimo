require 'factory_girl'

FactoryGirl.find_definitions <% if options['zeus'] -%>unless zeus_running? <% end %>
World FactoryGirl::Syntax::Methods

