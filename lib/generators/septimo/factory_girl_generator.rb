# frozen_string_literal: true

require_relative 'base'

module Septimo
  class FactoryGirlGenerator < Rails::Generators::Base
    include Base

    class_option :rspec, type: :boolean, default: true, desc: 'setup for rspec'
    class_option :cucumber, type: :boolean, default: false, desc: 'setup for cucumber'
    class_option 'skip-generator', type: :boolean, default: false, desc: 'skip RAILS generators configuration'

    desc <<~EOS
      Description
        Install and configure factory_girl with optionnal setup for rspec and cucumber

        If you plan to use factory_girl with zeus, please run the relevant generator.

    EOS

    def install
      install_gems
      install_spec if options[:rspec]
      install_template('features/support/factory_girl.rb') if options[:cucumber]
      install_generator
    end

    private

    def install_gems
      gems_installer do
        gem 'factory_girl_rails', group: :development
      end
    end

    def install_spec
      install_file('spec/factories_spec.rb')
      install_template('spec/support/factory_girl_helper.rb')
    end

    def install_generator
      inject_generator('g.factory_girl true')
      inject_generator("g.factory_girl dir: 'factories'")
    end
  end
end
