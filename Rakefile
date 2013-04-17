require "bundler/gem_tasks"
require "rake/testtask"
 
Rake::TestTask.new do |t|
  t.libs << 'lib/ovec'
  t.test_files = FileList['test/lib/ovec/*.rb']
  t.verbose = true
end
 
task :default => :test
