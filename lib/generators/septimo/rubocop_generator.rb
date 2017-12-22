# frozen_string_literal: true

require_relative 'base'

module Septimo
  class RubocopGenerator < Rails::Generators::Base
    include Base

    class_option :rspec, type: :boolean, default: true, desc: 'use rspec'

    def install
      install_gems
      copy_config
      clean_up
    end

    private

    def copy_config
      install_template('.rubocop.yml', '.rubocop.yml')
    end

    def install_gems
      gems_installer do
        gem_group :development, :test do
          gem 'rubocop'
          gem 'rubocop-rspec' if options[:rspec]
          gem 'rubocop-thread_safety'
        end
      end
    end

    def clean_up
      gsub_file('config/environments/development.rb', "'tmp/caching-dev.txt'", "Rails.root.join('tmp', 'caching-dev.txt')")
    end
  end
end
