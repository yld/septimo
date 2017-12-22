# frozen_string_literal: true

require_relative 'base'

module Septimo
  class HamlGenerator < Rails::Generators::Base
    include Base

    class_option :run, type: :boolean, default: true, desc: 'convert erb template into haml'

    desc <<~EOS
      Description
        Install haml and its generators.
        Translate erb templates into haml (unless --no-run option is provided)

    EOS

    def install
      install_gems
      install_generator
      run
    end

    private

    def install_gems
      gems_installer do
        gem 'haml-rails'
      end
    end

    def run
      run_inside_destination_root('rake haml:erb2haml')
    end

    def install_generator
      inject_generator('g.template_engine :haml') if options[:run]
    end
  end
end
