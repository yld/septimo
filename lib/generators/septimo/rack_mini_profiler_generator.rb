# frozen_string_literal: true

require_relative 'base'

module Septimo
  class RackMiniProfilerGenerator < Rails::Generators::Base
    include Base

    class_option :rspec, type: :boolean, default: true, desc: 'use reek in specs'
    class_option :spa, type: :boolean, default: false, desc: 'handle SPA application'
    class_option :task, type: :boolean, default: false, desc: 'install reek task'

    desc 'install and setup rack-mini-profiler'

    def install
      install_gems
      install_file('config/initializers/rack_mini_profiler.rb')
    end

    private

    def install_gems
      gems_installer do
        gem_group :development, :test do
          gem 'rack-mini-profiler', require: false
          gem 'memory_profiler'
          gem 'flamegraph'
          gem 'stackprof'
        end
      end
    end

    def install_spa_support
      return unless options[:spa]
      say 'add window.MiniProfiler.pageTransition(); on route transition'
      say 'look at  <script async type="text/javascript" id="mini-profiler" src="/mini-profiler-resources/includes.js?v=12b4b45a3c42e6e15503d7a03810ff33" data-version="12b4b45a3c42e6e15503d7a03810ff33" data-path="/mini-profiler-resources/" data-current-id="redo66j4g1077kto8uh3" data-ids="redo66j4g1077kto8uh3" data-horizontal-position="left" data-vertical-position="top" data-trivial="false" data-children="false" data-max-traces="10" data-controls="false" data-authorized="true" data-toggle-shortcut="Alt+P" data-start-hidden="false" data-collapse-results="true"></script>'
    end
  end
end
