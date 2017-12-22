# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/guard_generator'

module Septimo
  describe GuardGenerator do
    context 'when target is an application' do
      include_context 'dummy application'

      context 'with default arguments' do
        before(:all) { run_generator }

        it_behaves_like 'a generator generating a valid Gemfile'

        it 'generates a Guardfile' do
          expect('Guardfile').to be_a_file
        end

        it 'generates a valid Guardfile' do
          expect(run_inside_destination_root('bundle exec guard list >> /dev/null')).to eq(0)
        end
      end

      %w[rails-best-practices brakeman minitest reek cucumber rspec rubocop].each do |argument|
        context "with '--#{argument}'" do
          before { run_generator ["--#{argument}"] }
          it "installs #{argument} guard" do
            puts "bundle exec guard list | grep #{argument.tr('-', '_').capitalize} "
            expect(run_inside_destination_root("bundle exec guard list | grep #{argument.tr('-', '_').capitalize} >> /dev/null")).to eq(0)
          end
        end
      end
    end
  end
end
