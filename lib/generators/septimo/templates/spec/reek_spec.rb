# frozen_string_literal: true

require 'spec_helper'
require 'reek/spec'
require 'pathname'

RSpec.describe 'source code quality' do
  Pathname.glob(['./**/*.rb', './**/*.rake']).each do |path|
    it "reports no reek smells in #{path}" do
      # TODO: simplify it with reek 4.7.3, see https://github.com/troessner/reek/issues/1093
      expect(path).not_to reek(Reek::Configuration::AppConfiguration.from_path)
    end
  end
end
