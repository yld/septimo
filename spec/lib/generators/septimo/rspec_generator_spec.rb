# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/rspec_generator'

module Septimo
  describe RspecGenerator do
    context 'when target is an application' do
      include_context 'dummy application'
      context 'with default parameters' do
        before { run_generator }

        it 'installs rspec' do
          expect(run_inside_destination_root('bundle exec rspec')).to eq(0)
        end

        it "generates 'spec/rails_helper.rb'" do
          expect('spec/rails_helper.rb').to be_a_file
        end

        it "generates 'spec/spec_helper.rb'" do
          expect('spec/spec_helper.rb').to be_a_file
        end
      end
    end
  end
end
