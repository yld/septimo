# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/json_generator'

module Septimo
  describe JsonGenerator do
    context 'when target is an application' do
      include_context 'dummy application'

      context 'with --cucumber option' do
        before { run_generator %w[--cucumber] }

        it "installs 'features/support/json_spec.rb'" do
          expect('features/support/json_spec.rb').to be_a_file
        end
      end

      context 'with --no-rspec option' do
        before { run_generator %w[--no-rspec] }

        it "does not install 'spec/support/jsonapi-resources-matchers.rb'" do
          expect('spec/support/jsonapi-resources-matchers.rb').not_to be_a_file
        end

        it "does not install 'spec/support/json_matchers.rb'" do
          expect('spec/support/json_matchers.rb').not_to be_a_file
        end
      end

      context 'with --api option' do
        before { run_generator %w[--api] }

        it 'install active_model_serializers gem' do
          expect(has_gem?('active_model_serializers')).to be_truthy
        end

        it "installs 'spec/support/jsonapi-resources-matchers.rb'" do
          expect('spec/support/jsonapi-resources-matchers.rb').not_to be_a_file
        end

        it "installs 'spec/support/json_matchers.rb'" do
          expect('spec/support/json_matchers.rb').to be_a_file
        end

        it "installs JSONAPI schema file into 'spec/support/api/schemas/jsonapi.json'" do
          expect('spec/support/api/schemas/jsonapi.json').to be_a_file
        end
      end
      context 'with default options' do
        before { run_generator }

        it "generates 'spec/support/jsonapi-resources-matchers.rb'" do
          expect('spec/support/jsonapi-resources-matchers.rb').not_to be_a_file
        end
      end
    end
  end
end
