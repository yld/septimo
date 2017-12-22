# frozen_string_literal: true

# generator only matchers

def path_inside_destination(path)
  File.expand_path(path, destination_root)
end

RSpec::Matchers.define :be_a_file do
  match do |path|
    File.exist?(path_inside_destination(path))
  end
end

RSpec::Matchers.define :be_writable do
  match do |path|
    File.writable?(path_inside_destination(path))
  end
end

RSpec::Matchers.define :be_executable do
  match do |path|
    File.executable?(path_inside_destination(path))
  end
end

RSpec::Matchers.define :be_readable do
  match do |path|
    File.readable?(path_inside_destination(path))
  end
end

RSpec::Matchers.define :be_a_symlink do
  match do |path|
    File.symlink?(path_inside_destination(path))
  end
end

# RSpec::Matchers.define :be_a_symlink_to do |expected|
#    match do |path|
#      return false unless File.symlink?(path)
#      target = File.readlink(path)
#      File.realpath(target) == File.realpath(expected)
#    end
# end

RSpec::Matchers.define :be_a_directory do
  match do |path|
    Dir.exist?(path_inside_destination(path))
  end
end
