# frozen_string_literal: true

require_relative '../generators_utils'

module Septimo
  class JsonApiGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    include GeneratorUtils

    def install
      gems_install
    end

    private

    def gems_install
      gems_installer do
        gem 'jsonapi-resources'
        gem 'jsonapi-resources-matchers', group: :development if options[:rspec]
      end
    end

    def install_rspec_support
      return unless options[:rspec]
      install_file('spec/support/jsonapi-resources-matchers.rb')
    end
  end
end
