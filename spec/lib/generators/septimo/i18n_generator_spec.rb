# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/i18n_generator'

module Septimo
  describe I18nGenerator do
    context 'when target is an application' do
      include_context 'dummy application'
      context 'with default parameters' do
        before { run_generator }

        it 'installs i18n_tasks config' do
          expect('config/i18n-tasks.yml').to be_a_file
        end

        it 'install i18n_tasks' do
          expect(run_inside_destination_root('i18n-tasks > /dev/null')).to eq(0)
        end
      end
      context "with '--tasks' as argument" do
        before { run_generator %w[--tasks] }

        it "install 'lib/tasks/i18n_spec.rake'" do
          expect('lib/tasks/i18n_spec.rake').to be_a_file
        end
      end

      context "with '--minitest' as argument" do
        before { run_generator %w[--minitest] }

        it "install 'test/i18n_test.rb'" do
          expect('test/i18n_test.rb').to be_a_file
        end
      end

      context "with '--rspec' as argument" do
        before { run_generator %w[--rspec] }

        it "install 'spec/i18n_spec_spec.rb.rb'" do
          expect('spec/i18n_spec.rb').to be_a_file
        end

        it 'install rspec fix for default locale' do
          expect('spec/support/fix_locales.rb').to be_a_file
        end
      end
    end
  end
end
