# frozen_string_literal: true

require_relative 'base'

module Septimo
  class EmberGenerator < Rails::Generators::NamedBase
    include Base

    class_option :cli, type: :boolean, default: true, desc: 'install ember-cli-rails'
    class_option :rspec, type: :boolean, default: true, desc: 'use rspec'
    class_option :jsonapi, type: :boolean, default: true, desc: 'jsonapi support'

    def install
      install_gems
      install_app
    end

    private

    def install_gems
      gems_installer do
        gem 'active_model_serializers'
        gem 'ember-cli-rails'
      end
    end

    def check_requirements
      # puts "result => #{run_inside_destination_root('command -v npm')}"
      # raise 'you need to install npm before running this generator' if run_inside_destination_root('command -v npm').to_i != 0
    end

    def install_app
      return unless options[:cli]
      check_requirements
      install_initializer
      generate_ember_app
      install_routes
    end

    def generate_ember_app
      run_inside_destination_root("ember new #{file_name} --skip-git")
      run_inside_destination_root('ember install ember-cli-rails-addon', suffix: file_name)
      run_inside_destination_root('rake ember:install')
    end

    def install_initializer
      install_template('config/initializers/ember.rb')
    end

    def install_routes
      route "mount_ember_app :#{file_name}, to: '/'"
    end
  end
end
