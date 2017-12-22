# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/simple_cov_generator'

module Septimo
  describe SimpleCovGenerator do
    context 'when target is an application' do
      include_context 'dummy application'

      context 'with default options' do
        it_behaves_like 'a generator running flawlessly'

        it 'creates .simplecov' do
          expect('.simplecov').to be_a_file
        end
      end
    end
  end
end
