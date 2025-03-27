# frozen_string_literal: true

require_relative 'lib/pidfile'

Gem::Specification.new do |s|
  s.name = 'pidfile'
  s.version = PidFile::VERSION
  s.authors = ['Samuel Mullen']
  s.email = 'samullen@gmail.com'
  s.homepage = 'http://github.com/samullen/pidfile'
  s.summary = 'A basic library for creating lockfiles for processes'
  s.test_files = Dir['test/**/*.rb']
  s.description = false
  s.files = [
    'LICENSE',
    'README.rdoc',
    'Rakefile',
    'lib/pidfile.rb',
  ] + s.test_files
end
