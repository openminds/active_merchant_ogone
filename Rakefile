require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the active_merchant_ogone plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the active_merchant_ogone plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActiveMerchantOgone'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "active_merchant_ogone"
    gemspec.summary = "A plugin for Ogone support in ActiveRecord."
    gemspec.description = "A plugin for Ogone support in ActiveRecord. "
    gemspec.email = "github@defv.be"
    gemspec.homepage = "http://github.com/DefV/active_merchant_ogone/tree/master"
    gemspec.authors = ["Jan De Poorter", "Simon Menke"]
    gemspec.add_dependency 'activemerchant', '>= 1.4.2'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
