# frozen_string_literal: true

require 'rails/generators'
require 'fileutils'
require 'rails'

module Septimo
  module Base
    def self.included(klass)
      klass.source_root File.expand_path('../templates', __FILE__)
    end

    def run_inside_destination_root(command, suffix: '')
      inside File.join(destination_root, suffix) do
        say_status :run, "#{command.gsub('>> /dev/null', '')} inside #{FileUtils.pwd}"
        Bundler.clean_system(command.to_s)
      end
      $CHILD_STATUS.exitstatus
    end

    def engine_path(path)
      engine = engine?
      engine ? "#{engine}/#{path}" : path
    end

    def spring?
      run_inside_destination_root('grep spring Gemfile')
    end

    def inject_generators(target_file, prefix)
      return if run_inside_destination_root("grep 'config.generators' #{target_file} >> /dev/null").zero?
      generators_string = "#{prefix}config.generators do |g|\n#{prefix}end\n"
      if engine?
        inject_into_class target_file, Engine, generators_string
      else
        inject_into_file target_file, generators_string, after: "Rails.application.configure do\n"
      end
    end

    # this method smells of :reek:TooManyStatements
    def inject_generator(string)
      target_file, prefix = '', '  '
      if engine?
        target_file = "lib/#{app_name}/engine.rb"
        prefix += '  '
      else
        target_file = 'config/environments/development.rb'
      end
      inject_generators(target_file, prefix)
      inject_into_file target_file, "#{prefix}  #{string}\n", after: "config.generators do |g|\n"
    end

    def engine?
      inside destination_root do
        Dir.glob('*/dummy')[0]
      end
    end

    def gems_installer
      yield if block_given?
      # run_inside_destination_root('bundle check')
      bundle_install
    end

    def mkdir(path)
      inside destination_root do
        FileUtils.mkdir_p(path)
      end
    end

    def bundle_install
      run_inside_destination_root('bundle install')
    end

    def install_template(src_path, dst_path = nil)
      template(src_path, dst_path ? dst_path : src_path)
    end

    def install_file(src_path, dst_path = nil)
      copy_file(src_path, dst_path ? dst_path : src_path)
    end

    def download_file(src, dst)
      run_inside_destination_root("wget #{src} -O #{dst} --quiet")
    end

    def prepend_spring_support(file)
      return unless options['zeus']
      prepend_to_file(file) do
        <<~EOS
          # This method smells of :reek:UtilityFunction
          def zeus_running?
            File.exist?('.zeus.sock') || File.exist?('./spec/dummy/.zeus.sock')
          end
        EOS
      end
    end

    def prepend_zeus_support(file)
      return unless options['zeus']
      prepend_to_file(file) do
        <<~EOS
          # This method smells of :reek:UtilityFunction
          def zeus_running?
            File.exist?('.zeus.sock') || File.exist?('./spec/dummy/.zeus.sock')
          end
        EOS
      end
    end

    def prepend_simple_cov_support(file)
      return unless options['simple-cov']
      prepend_to_file(file) do
        <<~EOS
          ### run simplecov before any test
          require 'simplecov' #{'unless zeus_running?' if options[:zeus]}
        EOS
      end
    end
  end
end
