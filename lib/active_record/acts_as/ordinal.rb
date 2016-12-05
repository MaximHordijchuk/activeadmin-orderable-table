module ActiveRecord
  module ActsAs
    module Ordinal
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        attr_reader :ordinal_field

        def acts_as_ordinal(options = {})
          @ordinal_field = options[:ordinal_field] || :ordinal

          class_eval do
            include ActiveRecord::ActsAs::Ordinal::InstanceMethods
          end
        end
      end

      module InstanceMethods
        def insert_at(position)
          return if position == ordinal
          (update("#{acts_ordinal_field}": position) && return) unless self.class.find_by("#{acts_ordinal_field}": position)
          if position > acts_ordinal_value
            items = self.class.where("#{acts_ordinal_field}": (acts_ordinal_value + 1)..position).order(acts_ordinal_field).to_a.push(self)
            positions = items.map { |item| item.send(acts_ordinal_field) }.rotate(-1)
          else
            items = self.class.where("#{acts_ordinal_field}": position...acts_ordinal_value).order(acts_ordinal_field).to_a.push(self)
            positions = items.map { |item| item.send(acts_ordinal_field) }.rotate
          end
          items.each_with_index { |item, index| item.update("#{acts_ordinal_field}": positions[index]) }
        end

        def acts_ordinal_field
          self.class.ordinal_field
        end

        def acts_ordinal_value
          self.send(acts_ordinal_field)
        end
      end
    end
  end
end
