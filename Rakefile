$:.unshift File.expand_path("../lib", __FILE__)

require 'rubygems'
require 'lib/pidfile'
require 'rake/testtask'
require 'rake/gempackagetask'

lib_dir = File.expand_path('lib')
test_dir = File.expand_path('test')

Rake::TestTask.new(:test) do |test|
  test.libs = [lib_dir, test_dir]
  test.pattern = 'test/**/*rb'
  test.verbose = true
end

Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

desc "Install the gem locally"
task :install => [:test, :gem] do
  sh %{gem install pkg/#{gem_spec.name}-#{gem_spec.version}}
end

desc "Remove the pkg directory and all of its contents."
task :clean => :clobber_package

task :default => [:test, :gem]
