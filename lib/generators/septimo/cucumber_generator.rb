# frozen_string_literal: true

require_relative 'base'

module Septimo
  class CucumberGenerator < Rails::Generators::Base
    include Base

    hook_for 'simple_cov', in: :septimo, as: 'simple-cov', type: :boolean, default: true, desc: 'use simple-cov'
    class_option :guard, type: :boolean, default: true, desc: 'install guard profile'
    class_option :zeus, type: :boolean, default: true, desc: 'zeus setup'

    desc <<~EOS
      Description
        Install cucumber with various options.

        Please note that spork support won't be installed.

    EOS

    def install
      install_gems
      install_cucumber
      install_cucumber_env
    end

    private

    def install_gems
      gems_installer do
        gem_group :test do
          gem 'cucumber-rails', require: false
          gem 'database_cleaner'
        end
        gem 'spring-commands-cucumber', group: :development if spring?
      end
    end

    def install_cucumber
      run_inside_destination_root('rails generate cucumber:install  --no-spork --no-skip-database')
      gsub_file('config/cucumber.yml', /~@(\w+)/, '\'not @\1\'')
      append_to_file('config/cucumber.yml', "guard: <%= std_opts %> features\n") if options[:guard]
    end

    def install_cucumber_env
      prepend_simple_cov_support('features/support/env.rb') if options['simple-cov']
      prepend_zeus_support('features/support/env.rb') if options[:zeus]
    end
  end
end
