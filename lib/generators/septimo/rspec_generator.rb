# frozen_string_literal: true

require_relative 'base'

module Septimo
  class RspecGenerator < Rails::Generators::Base
    include Base

    hook_for 'simple_cov', in: :septimo, as: 'simple-cov', type: :boolean, default: true, desc: 'use simple-cov'
    class_option :zeus, type: :boolean, default: false, desc: 'install zeus support'

    desc <<~EOS
      Description
        Install rspec rails and several rspec dependant gems.

        Please note that it won't install zeus, use the appropriate genrator as needed.

    EOS

    def install
      install_gems
      run_inside_destination_root('rails g rspec:install')
      update_spec_helper
      update_rails_helper
      install_support_files
      generate_binstub
    end

    private

    def install_gems
      gems_installer do
        gem_group :development, :test do
          gem 'rspec-rails'
          gem 'rspec-activemodel-mocks'
          gem 'rspec-collection_matchers'
          gem 'rails-controller-testing'
          gem 'rspec-its'
          gem 'email_spec', '>= 1.2.1'
          gem 'shoulda-matchers', '>= 3.1'
        end
        gem 'spring-commands-rspec', group: :development if spring?
      end
    end

    def generate_binstub
      run_inside_destination_root('bundle exec spring binstub rspec') if spring?
    end

    def update_spec_helper
      prepend_simple_cov_support('spec/spec_helper.rb')
      prepend_zeus_support('spec/spec_helper.rb')
      uncomment_lines('spec/spec_helper.rb', /config.order = :random/)
      uncomment_lines('spec/spec_helper.rb', 'config.disable_monkey_patching')
      gsub_file 'features/support/env.rb', "require File.expand_path('../../../config/environment', __FILE__)\n", "require File.expand_path('../../../spec/dummy/config/environment', __FILE__)\n" if engine?
    end

    def update_rails_helper
      gsub_file 'spec/rails_helper.rb', "ENV['RAILS_ENV'] ||= 'test'\n", "ENV['RAILS_ENV'] = 'test'\n"
      gsub_file 'spec/rails_helper.rb', "# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }\n", "Dir['./spec/support/**/*.rb'].each { |file| require file } unless zeus_running?\n"
      gsub_file('spec/rails_helper.rb', "require File.expand_path('../../config/environment', __FILE__)\n", "require File.expand_path('../../spec/dummy/config/environment', __FILE__)\n") if engine?
      comment_lines('spec/rails_helper.rb', /config.fixture_path/)
    end

    def install_support_files
      install_file('spec/support/shoulda_matchers.rb')
    end
  end
end
