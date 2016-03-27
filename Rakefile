require "bundler/gem_tasks"
require "rake/testtask"
require "rdoc/task"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

Rake::RDocTask.new do |rd|
  rd.rdoc_dir = "doc"
  rd.main = "README.md"
  rd.rdoc_files.include("README.md", "lib/**/*.rb")
end

