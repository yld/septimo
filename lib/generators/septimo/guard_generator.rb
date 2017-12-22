# frozen_string_literal: true

require_relative 'base'

module Septimo
  class GuardGenerator < Rails::Generators::Base
    include Base

    class_option 'rails-best-practices', type: :boolean, default: false, desc: 'install rails_best_practices guard'
    class_option :brakeman, type: :boolean, default: false, desc: 'install brakeman guard'
    class_option :cucumber, type: :boolean, default: false, desc: 'install cucumber guard'
    class_option :jshint, type: :boolean, default: false, desc: 'install jshint guard'
    class_option :minitest, type: :boolean, default: false, desc: 'install minitest guard'
    class_option :reek, type: :boolean, default: false, desc: 'install reek guard'
    class_option :rspec, type: :boolean, default: false, desc: 'install rspec guard'
    class_option :rubocop, type: :boolean, default: false, desc: 'install reek guard'
    class_option :zeus, type: :boolean, default: false, desc: 'prefix commands with zeus (when possible)'

    desc('Install guard with various tools support')

    def install
      install_gems
      install_template('Guardfile')
    end

    private

    def install_gems
      gems_installer do
        gem_group :development do
          gem 'guard'
          gem 'guard-brakeman' if options[:brakeman]
          gem 'guard-bundler'
          gem 'guard-coffeescript'
          gem 'guard-consistency_fail', github: 'yld/guard-consistency_fail'
          gem 'guard-ctags-bundler'
          gem 'guard-cucumber', '>= 2.0.0' if options[:cucumber]
          gem 'guard-livereload'
          gem 'guard-migrate'
          gem 'guard-minitest' if options[:minitest]
          gem 'guard-puma'
          gem 'guard-rails_best_practices', github: 'logankoester/guard-rails_best_practices' if options['rails-best-practices']
          gem 'guard-reek' if options[:reek]
          gem 'guard-rspec' if options[:rspec]
          gem 'guard-rubocop' if options[:rubocop]
          gem 'guard-sidekiq' if options[:sidekiq]
        end
      end
    end
  end
end
