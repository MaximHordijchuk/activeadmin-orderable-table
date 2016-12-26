# -*- encoding: utf-8 -*-
require File.expand_path('../lib/activeadmin-orderable/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'activeadmin-orderable'
  s.version = Activeadmin::Orderable::VERSION
  s.date = Time.new.strftime('%Y-%m-%d')
  s.summary = 'Order ActiveAdmin tables'
  s.description = 'Drag and drop order interface for ActiveAdmin tables'
  s.authors = ['Max Hordiichuk']
  s.email = 'hordijchuk.m.i@gmail.com'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/MaximHordijchuk/activeadmin-orderable'
  s.license = 'MIT'

  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'test-unit', '~> 3.0'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'sass-rails'

  s.add_runtime_dependency 'activeadmin'
  s.add_runtime_dependency 'sortable-rails', '~> 1.4'
end
