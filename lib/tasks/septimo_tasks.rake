# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'

namespace :septimo do
  def generate_rails_dummy(dir, command)
    FileUtils.cd(dir) do
      system(command)
      system('bundle exec rails db:migrate')
      sytem('touch .gitignore')
    end
  end

  # this method smells of :reek:UtilityFunction
  def copy_rails_dummy(dir, dummy_name)
    dst = File.join(File.expand_path('spec'), dummy_name)
    FileUtils.rm_rf(dst, secure: true)
    FileUtils.copy_entry(File.expand_path(dummy_name, dir), dst)
    FileUtils.cd(dst) { system 'rubocop -aR' }
  end

  desc 'Creates a dummy application'
  task :dummy_app do
    Dir.mktmpdir('septimo') do |dir|
      generate_rails_dummy(dir, 'rails new dummy_app  --quiet -f --skip-bundle  --skip-test --skip-git --no-rc')
      copy_rails_dummy(dir, 'dummy_app')
    end
  end

  desc 'Creates a dummy engine'
  task :dummy_engine do
    Dir.mktmpdir('septimo') do |dir|
      generate_rails_dummy(dir, 'rails new dummy_engine  --quiet -f --skip-bundle  --skip-test --skip-git --no-rc')
      copy_rails_dummy(dir, 'dummy_engine')
    end
  end

  desc 'Creates dummy engine and dummy application'
  task dummies: %i[dummy_app dummy_engine]
end
