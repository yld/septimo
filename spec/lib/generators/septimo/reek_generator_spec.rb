# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/reek_generator'

module Septimo
  describe ReekGenerator do
    context 'when target is an application' do
      include_context 'dummy application'

      context 'with default arguments' do
        before(:all) { run_generator }
        it_behaves_like 'a generator generating a valid Gemfile'

        it 'install reek configuration' do
          expect('.reek').to be_a_file
        end

        it 'does not install Rake task' do
          expect('lib/tasks/reek_task.rake').not_to be_a_file
        end

        it 'reek runs flawlessly' do
          expect([0, 2]).to include(run_inside_destination_root('bundle exec reek --config .reek .').to_i)
        end
      end

      context "with '--tasks' flag" do
        before(:all) { run_generator %w[--tasks] }

        it 'installs Rake task file' do
          expect('lib/tasks/reek_task.rake').to be_a_file
        end

        it 'installs Rake task' do
          expect(has_task?('reek')).to be_truthy
        end
      end

      context "with '--rspec' flag" do
        before(:all) { run_generator %w[--rspec] }

        it 'install reek spec' do
          expect('spec/reek_spec.rb').to be_a_file
        end

        it 'install reek spec helper' do
          expect('spec/support/reek_helper.rb').to be_a_file
        end
      end
    end
  end
end
