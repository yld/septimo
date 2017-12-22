# frozen_string_literal: true

require_relative 'base'

module Septimo
  class SimpleCovGenerator < Rails::Generators::Base
    include Base

    desc <<~EOS
      Description
        install and configure simple_cov with various coverage formatters

    EOS

    def install
      install_gems
      copy_config
      gitignore_install
    end

    private

    def gitignore_install
      run_inside_destination_root('grep coverage .gitignore >> /dev/null || echo coverage >> .gitignore')
    end

    def copy_config
      install_file('.simplecov')
    end

    def install_gems
      gems_installer do
        gem_group :test do
          gem 'simplecov', require: false
          gem 'simplecov-rcov-text', require: false
          gem 'simplecov-json', require: false
          gem 'simplecov-cobertura', require: false
          gem 'simplecov-html', require: false
        end
      end
    end
  end
end
