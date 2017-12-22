# frozen_string_literal: true

require_relative 'base'
require 'json'

module Septimo
  class ZeusGenerator < Rails::Generators::Base
    include Base

    class_option :cucumber, type: :boolean, default: true, desc: 'use cucumber'
    class_option :guard, type: :boolean, default: true, desc: 'use guard'
    class_option :rspec, type: :boolean, default: true, desc: 'use rspec'
    class_option :sidekiq, type: :boolean, default: false, desc: 'use sidekiq'
    class_option 'simple-cov', type: :boolean, default: true, desc: 'use simple_cov'
    class_option 'factory-girl', type: :boolean, default: true, desc: 'use factory_girl'
    class_option 'remove-spring', type: :boolean, default: false, desc: 'remove sping from Gemfile and binstubs'

    desc <<~EOS
      Description
        Install zeus preloader with support for rspec, cucumber, or sidekiq. It may also remove spring support.

        Please note that it won't install cucumber nor rspec, use the appropriate genrator as needed.
    EOS

    def install
      install_gems
      run_inside_destination_root 'zeus init'
      install_template('custom_plan.rb')
      install_zeus_json
      remove_spring if options['remove-spring']
    end

    private

    def install_gems
      gems_installer do
        gem_group :development do
          gem 'zeus', require: false
        end
      end
    end

    def load_zeus_json
      @zeus_json_path = File.join(destination_root, 'zeus.json')
      @json_config = JSON.parse File.read(@zeus_json_path)
    end

    def install_zeus_json
      load_zeus_json
      append_developement_command('sidekiq', %w[sidek k]) if options[:sidekiq]
      @json_config['plan']['boot']['default_bundle']['test_environment']['cucumber_environment'] = { cucumber: %w[cuke] } if options['cucumber']
      File.open(@zeus_json_path, 'w') { |file| file.write(@json_config.to_json) }
    end

    def append_developement_command(command, aliases = [])
      @json_config['plan']['boot']['default_bundle']['development_environment'][command] = aliases
    end

    def remove_spring
      return unless run_inside_destination_root('grep spring Gemfile').zero?
      run_inside_destination_root('bin/spring server stop >> /dev/null')
      run_inside_destination_root('bin/spring binstub --remove --all')
      run_inside_destination_root("sed -i '/spring/d' Gemfile")
      # run_inside_destination_root('bundle clean --force')
    end
  end
end
