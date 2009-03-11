require 'rake'
require 'spec/rake/spectask'

desc 'Run all specs for the ActiveRecord Reflection Matchers'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.verbose = true
end

desc "Run all the tests"
task :default => :spec