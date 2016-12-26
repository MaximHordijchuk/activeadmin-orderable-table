require 'sqlite3'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(:version => 1) do
  create_table "entities", :force => true do |t|
    t.integer  "ordinal", null: false
  end
end

class Entity < ActiveRecord::Base
  acts_as_ordinal
end
