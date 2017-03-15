require 'activeadmin-orderable-table'
require 'activeadmin'
require 'db_helper'
require 'rspec/rails'
require 'support/utilities'

RSpec.configure do |config|
  config.warnings = true
  config.order = :random
end
