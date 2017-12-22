# frozen_string_literal: true

require_relative 'base'

module Septimo
  class I18nGenerator < Rails::Generators::Base
    include Base

    class_option :minitest, type: :boolean, default: false, desc: 'use reek in specs'
    class_option :rspec, type: :boolean, default: false, desc: 'install rspec fix for hanfling locale in parameters'
    class_option :tasks, type: :boolean, default: false, desc: 'install i18n_spec task'

    def install
      install_gems
      configure_i18_tasks
      install_test_files
      install_tasks if options[:tasks]
      generate_default_locale
    end

    private

    def default_locale
      @default_locale = ENV['LANG'].split('.')[0]
    end

    def configure_i18_tasks
      run_inside_destination_root('cp $(bundle exec i18n-tasks gem-path)/templates/config/i18n-tasks.yml config/')
      gsub_file('config/i18n-tasks.yml', 'base_locale: en', "base_locale: #{@default_locale}")
    end

    def generate_default_locale
      run_inside_destination_root("rails g i18n_locale $(echo ${LANG}|cut -f1 -d '.')")
      # TODO: add other locales or say
      say('you can fetch others locales as ndicated there https://github.com/amatsuda/i18n_generators#1-generate-locale-files-for-activerecordactivesupportactionpackactionview')
    end

    def install_gems
      gems_installer do
        gem_group :development, :test do
          gem 'i18n-tasks'
          gem 'i18n-spec'
          gem 'i18n_data' # country and so on
        end
        gem 'i18n_generators', group: :development
      end
    end

    def install_test_files
      install_rspec_files if options[:rspec]
      # TODO: when where
      install_file('spec/support/fix_locales.rb')
      install_test_files if options[:minitest]
    end

    def install_rspec_files
      mkdir('spec')
      run_inside_destination_root('cp $(bundle exec i18n-tasks gem-path)/templates/rspec/i18n_spec.rb spec/i18n_tasks_spec.rb')
      install_file('spec/i18n_spec.rb')
    end

    def install_minitest_files
      mkdir('test')
      run_inside_destination_root('cp $(i18n-tasks gem-path)/templates/minitest/i18n_test.rb test/')
    end

    def install_tasks
      install_file('lib/tasks/i18n_spec.rake')
    end
  end
end
