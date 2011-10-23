begin
  require 'rspec'

  desc "Run fast specs"
  RSpec::Core::RakeTask.new(:fast) do |task|
    task.pattern = 'fast_specs/**/*_spec.rb'
    task.rspec_opts = '-Ifast_specs'
  end

  task :default => :fast
rescue LoadError
  desc "Run fast specs"
  task :fast do
    abort 'Fast specs rake task is not available.'
  end
end
