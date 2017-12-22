# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/rack_mini_profiler_generator'

module Septimo
  describe RackMiniProfilerGenerator do
    context 'when target is an application' do
      include_context 'dummy application'
      context 'with default parameters' do
        before { run_generator }

        it 'installs rack_mini_profiler initializer' do
          expect('config/initializers/rack_mini_profiler.rb').to be_a_file
        end
      end
    end
  end
end
