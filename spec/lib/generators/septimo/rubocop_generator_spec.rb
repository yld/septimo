# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/rubocop_generator'

module Septimo
  describe RubocopGenerator do
    context 'when target is an application' do
      include_context 'dummy application'

      before { run_generator }

      it_behaves_like 'a generator generating a valid Gemfile'
      it 'install rubocop configuration' do
        expect('.rubocop.yml').to be_a_file
      end

      it 'rubocop configuration is set to current Ruby version' do
        assert File.readlines('.rubocop.yml').grep("TargetRubyVersion: #{RUBY_VERSION.match(/\d+\.\d+/)}")
      end

      it 'rubocop runs flawlessly' do
        expect(run_inside_destination_root('bundle exec rubocop -Ra')).not_to eql(2)
      end
    end
  end
end
