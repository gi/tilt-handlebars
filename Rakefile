require "bundler/gem_tasks"
require 'rake/testtask'

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
  t.ruby_opts = ['-Itest']
end

task :default => :test
