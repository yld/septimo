# frozen_string_literal: true

require_relative 'base'

module Septimo
  class ReekGenerator < Rails::Generators::Base
    include Base

    class_option :rspec, type: :boolean, default: true, desc: 'use reek in specs'
    class_option :tasks, type: :boolean, default: false, desc: 'install reek task'

    desc <<~EOS
      Description
        Install reek with optionnal rspec support.

    EOS
    def install
      install_gems
      copy_config
      install_file('lib/tasks/reek_task.rake') if options[:tasks]
      install_spec if options[:rspec]
    end

    private

    def install_gems
      gems_installer do
        gem_group :development, :test do
          gem 'reek'
        end
      end
    end

    def install_spec
      create_file 'spec/support/reek_helper.rb', "require 'reek/spec'\n"
      install_file('spec/reek_spec.rb')
    end

    def copy_config
      template('.reek', '.reek')
    end
  end
end
