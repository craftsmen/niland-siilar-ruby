require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.verbose = !!ENV['VERBOSE']
end

task test: :spec
task default: :spec
