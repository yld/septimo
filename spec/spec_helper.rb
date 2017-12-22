# frozen_string_literal: true

require 'fileutils'
# see https://github.com/bbatsov/rubocop/issues/1747
require 'English'

require 'generator_spec'

Dir[File.dirname(__FILE__) + '/matchers/**/*.rb'].each do |file|
  load File.expand_path(file)
end

# WARNING this example leaves a genrated application
shared_examples 'a generator running flawlessly' do
  it 'runs without errors' do
    expect { run_generator }.not_to raise_error
  end
  it_behaves_like 'a generator generating a valid Gemfile'
end

shared_examples 'a generator generating a valid Gemfile' do
  it 'pass bundle check successfully' do
    expect(bundle_check).to be_truthy
  end
end

shared_context 'dummy engine' do
  destination File.expand_path(File.join('..', '..', 'tmp'), __FILE__)
  before(:all) do
    generate_dummy_engine
  end
  arguments %w[--engine]
  it_behaves_like 'a generator running flawlessly'
end

shared_context 'dummy application' do
  destination File.expand_path(File.join('..', '..', 'tmp'), __FILE__)
  arguments []
  before(:all) do
    generate_dummy_app
  end
  it_behaves_like 'a generator running flawlessly'
end

# * generate sample app/engine
# * run system commands inside target directory without bundler hassle
module GeneratorSpecHelper
  def run_inside_destination_root(command)
    FileUtils.cd(destination_root) do
      puts "Runnning #{command} inside #{FileUtils.pwd}"
      Bundler.clean_system(command)
    end
    $CHILD_STATUS.exitstatus
  end

  def has_gem?(gem_name)
    run_inside_destination_root("gem list |grep #{gem_name}") == 0
  end

  def has_task?(task_name)
    run_inside_destination_root("rake -T grep 'rake #{task_name}'") == 0
  end

  def bundle_check
    run_inside_destination_root('bundle check >> /dev/null')
  end

  def generate_dummy_app
    prepare_destination
    FileUtils.copy_entry(File.expand_path(File.join('..', '..', 'spec', 'dummy_app'), __FILE__), destination_root)
  end

  def generate_dummy_engine
    prepare_destination
    FileUtils.copy_entry(File.expand_path(File.join('..', '..', 'spec', 'dummy_engine'), __FILE__), destination_root)
  end
end

RSpec.configure do |c|
  c.include GeneratorSpecHelper
end
