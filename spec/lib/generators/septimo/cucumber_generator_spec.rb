# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/cucumber_generator'

module Septimo
  describe CucumberGenerator do
    context 'when target is an application' do
      include_context 'dummy application'

      context 'with default options' do
        it 'runs cucumber flawlessly' do
          expect(run_inside_destination_root('cucumber')).to eq(0)
        end
      end
    end
  end
end
