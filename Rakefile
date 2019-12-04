require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  desc "Run RSpec unit tests"
  task :test do
    RSpec::Core::RakeTask.new(:spec) do |test|
      test.pattern = 'spec/**{,/*/**}/*_spec.rb'
    end
    Rake::Task["spec"].execute
  end
rescue LoadError
  puts "Failed to load rspec"
end
