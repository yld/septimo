# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/factory_girl_generator'

module Septimo
  describe FactoryGirlGenerator do
    context 'when target is an engine' do
      include_context 'dummy engine'
    end
    context 'when target is an application' do
      include_context 'dummy application'

      context 'with default arguments' do
        before { run_generator }
        it_behaves_like 'a generator generating a valid Gemfile'
      end

      context "with '--rspec' flag" do
        before(:all) { run_generator(%w[--rspec]) }
        it 'install factories spec' do
          expect('spec/factories_spec.rb').to be_a_file
        end

        it 'install rspec support' do
          expect('spec/support/factory_girl_helper.rb').to be_a_file
        end
      end

      context "with '--cucumber' flag" do
        it 'install cucumber support' do
          run_generator(%w[--cucumber])
          expect('features/support/factory_girl.rb').to be_a_file
        end
      end
    end
  end
end
