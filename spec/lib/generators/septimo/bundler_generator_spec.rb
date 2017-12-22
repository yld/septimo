# frozen_string_literal: true

require 'spec_helper'
require 'generators/septimo/bundler_generator'

module Septimo
  describe BundlerGenerator do
    include_context 'dummy application'
    it_behaves_like 'a generator running flawlessly'
    it_behaves_like 'a generator generating a valid Gemfile'
  end
end
