# -*- encoding: utf-8 -*-
require File.expand_path('../lib/activeadmin-ordinal/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'activeadmin-ordinal'
  s.version = Activeadmin::Ordinal::VERSION
  s.date = Time.new.strftime('%Y-%m-%d')
  s.summary = 'Order ActiveAdmin tables'
  s.description = 'Drag and drop order interface for ActiveAdmin tables'
  s.authors = ['Max Hordiichuk']
  s.email = 'hordijchuk.m.i@gmail.com'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/MaximHordijchuk/activeadmin-ordinal'
  s.license = 'MIT'

  s.add_development_dependency 'bundler', '~> 1.10'

  s.add_runtime_dependency 'activeadmin'
  s.add_runtime_dependency 'sortable-rails', '~> 1.4'
end
