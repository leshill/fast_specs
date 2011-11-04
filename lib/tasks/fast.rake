begin
  require 'rspec'

  desc "Run fast specs"
  RSpec::Core::RakeTask.new(:fast) do |task|
    task.pattern = 'fast_specs/**/*_spec.rb'
    task.rspec_opts = '-Ifast_specs'
  end

  task :default => :fast

  # Ridiculous override needed until this commit 8a4239fc7e6669da9843e5aa28b5ba2a47f26b6f shows up in Rails
  task :test => :fast

rescue LoadError
  desc "Run fast specs"
  task :fast do
    abort 'Fast specs rake task is not available.'
  end
end
