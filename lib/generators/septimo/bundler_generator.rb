# frozen_string_literal: true

require_relative 'base'

module Septimo
  class BundlerGenerator < Rails::Generators::Base
    include Base
    class_option :tasks, type: :boolean, default: true, desc: 'install bundle audit task'
    class_option 'skip-reorganize', type: :boolean, default: false, desc: 'do not reoganize Gemfile'

    desc <<~EOS
      Description
        install various tools for Gemfile optimization and auditing

      Example
        rails g septimo:bundler --no-taks

        install bundle-audit, bundler-reorganizer and bundler-auto-update without any task, then clean up Gemfile
    EOS

    def install
      install_gems
      install_task
      clean_up_gemfile
    end

    private

    def install_gems
      gems_installer do
        gem_group :development do
          gem 'bundler-auto-update', require: false
          gem 'bundle-audit', require: false
          gem 'bundler-reorganizer', require: false
        end
      end
    end

    def clean_up_gemfile
      return if options['skip-reorganize']
      destination_root_gemfile = "#{destination_root}/Gemfile"
      gsub_file destination_root_gemfile, /^git_source.*\n.*\n.*\nend/, ''
      run_inside_destination_root('bundler-reorganizer Gemfile >> /dev/null')
      prepend_to_file destination_root_gemfile do
        <<~EOS
          git_source(:github) do |repo_name|
            repo_name = "\#{repo_name}/\#{repo_name}" unless repo_name.include?('/')
            "https://github.com/\#{repo_name}.git"
          end

        EOS
      end
      run_inside_destination_root('command rubocop -a Gemfile >> /dev/null')
    end

    def install_task
      return unless options[:tasks]
      install_file('lib/tasks/bundle_audit.rake')
    end
  end
end
