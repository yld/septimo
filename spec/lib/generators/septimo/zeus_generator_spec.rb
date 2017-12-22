# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/zeus_generator'

module Septimo
  describe ZeusGenerator do
    context 'when target is an application' do
      include_context 'dummy application'

      context 'with default options' do
        it_behaves_like 'a generator running flawlessly'

        it 'creates zeus.json' do
          expect('zeus.json').to be_a_file
        end

        it 'creates custom_plan.rb' do
          expect('custom_plan.rb').to be_a_file
        end
      end
    end
  end
end
