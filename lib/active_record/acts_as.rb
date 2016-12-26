require 'active_record/base'

module ActiveRecord
  class Base
    include ActsAs::Orderable
  end
end
