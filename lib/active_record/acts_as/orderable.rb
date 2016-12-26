module ActiveRecord
  module ActsAs
    module Orderable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        attr_reader :ordinal_field, :starts_from

        def acts_as_orderable(options = {})
          @ordinal_field = options[:ordinal_field] || :ordinal
          @starts_from = options[:starts_from] || 0

          validates @ordinal_field, presence: true
          validate :check_ordinal_uniqueness
          before_validation :set_defaults

          class_eval do
            include ActiveRecord::ActsAs::Orderable::InstanceMethods
          end
        end
      end

      module InstanceMethods
        def insert_at(position, ordinals_scope = nil)
          return if position == acts_ordinal_value # if ordinal haven't changed

          # if new position is not occupied just take this ordinal
          unless self.class.where("#{acts_ordinal_field}": position).first
            update_attributes("#{acts_ordinal_field}": position)
            return
          end

          items = items_scoped(position, ordinals_scope)
          current_positions = items.map { |item| item.send(acts_ordinal_field) }
          reordered_positions = reorder_positions(position, current_positions)
          update_ordinals(items, reordered_positions)
        end

        def acts_ordinal_field
          self.class.ordinal_field
        end

        def acts_ordinal_value
          self.send(acts_ordinal_field)
        end

        def starts_from
          self.class.starts_from
        end

        private

        def ordinal_range(position)
          position > acts_ordinal_value ? (acts_ordinal_value + 1)..position : position...acts_ordinal_value
        end

        def items_scoped(position, ordinals_scope)
          actual_ordinals_scope = *ordinal_range(position)
          actual_ordinals_scope &= ordinals_scope if ordinals_scope
          self.class.where("#{acts_ordinal_field}": actual_ordinals_scope).order(acts_ordinal_field).to_a.push(self)
        end

        def reorder_positions(position, positions)
          position > acts_ordinal_value ? positions.rotate(-1) : positions.rotate
        end

        def update_ordinals(items, positions)
          items.each_with_index do |item, index|
            item.assign_attributes("#{acts_ordinal_field}": positions[index])
            item.save!(validate: false)
          end
        end

        def check_ordinal_uniqueness
          if acts_ordinal_value.present? &&
             self.class.where("#{acts_ordinal_field}": acts_ordinal_value).reject { |record| record == self }.first
            self.errors[acts_ordinal_field] << 'must be unique'
          end
        end

        def set_defaults
          if acts_ordinal_value.blank?
            ordinal_value_prev = self.class.maximum(acts_ordinal_field)
            ordinal_value_next = (ordinal_value_prev ? ordinal_value_prev + 1 : starts_from)
            assign_attributes("#{acts_ordinal_field}": ordinal_value_next)
          end
        end
      end
    end
  end
end
