module ActiveAdmin
  module OrderableTable
    module ControllerActions
      def orderable
        member_action :reorder, method: :post do
          position = params[:position].to_i
          if params[:ordinals]
            ordinals_scope = params[:ordinals].map { |ordinal| ordinal.to_i }
            resource.insert_at position, ordinals_scope
          else
            resource.insert_at position
          end
          head 200
        end
      end
    end

    module TableMethods
      HANDLE = '&#x2195;'.html_safe

      def orderable_handle_column
        column_name = resource_class.ordinal_field
        return if params[:order] != "#{column_name}_asc" && params[:order] != "#{column_name}_desc"

        column '', class: 'activeadmin-orderable-column' do |resource|
          reorder_path = resource_path(resource) + '/reorder'
          content_tag :span, HANDLE, class: 'activeadmin-orderable-handle', 'data-reorder-url': reorder_path,
                                     'data-ordinal': resource.acts_ordinal_value
        end
      end
    end

    ::ActiveAdmin::ResourceDSL.send(:include, ControllerActions)
    ::ActiveAdmin::Views::TableFor.send(:include, TableMethods)

    class Engine < ::Rails::Engine
      # Including an Engine tells Rails that this gem contains assets
    end
  end
end

