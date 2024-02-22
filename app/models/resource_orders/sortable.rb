module ResourceOrders::Sortable
  extend ActiveSupport::Concern

  included do
    delegate :sortable_attribute_names, to: :class
    delegate :sortable_attributes, :sortable_non_attributes, to: :class
  end

  class_methods do
    def sortable?
      true
    end

    def sortable_attribute_names
      %w(id name order_amount)
    end

    def sortable_attributes
      %w(id name)
    end

    def sortable_non_attributes
      sortable_attribute_names.dup - sortable_attributes
    end

    def order_by_sortable_attribute_name(sort_attribute = nil, sort_direction = nil)
      sort_attribute ||= 'id'
      sort_direction ||= 'desc'

      sort_attribute, sort_direction = format_sort_attribute(sort_attribute), format_sort_direction(sort_direction)

      if sort_attribute.in?(sortable_attribute_names)
        return order_by_sortable_attribute(sort_attribute, sort_direction) if sort_attribute.in?(sortable_attributes)
        return order_by_has_many_amount('orders', sort_direction) if (sort_attribute == 'order_amount')

        return order_by_id_desc
      end
    end

    private
      def order_by_id_desc
        reorder(id: :desc)
      end

      def order_by_string_attribute(sort_attribute, sort_direction)
        reorder("LOWER(#{sort_attribute}) #{sort_direction}")
      end

      def order_by_integer_attribute(sort_attribute, sort_direction)
        reorder("#{sort_attribute} #{sort_direction}")
      end

      def format_sort_attribute(sort_attribute)
        sort_attribute.downcase!
        sort_attribute = 'id' if !sort_attribute.in?(sortable_attribute_names)

        return sort_attribute
      end

      def format_sort_direction(sort_direction)
        sort_direction.downcase!
        sort_direction = 'desc' if !(sort_direction.in? %w(asc desc))

        return sort_direction
      end

      def order_by_sortable_attribute(sort_attribute, sort_direction)
        case columns_hash[sort_attribute].type
        when :datetime
          order_by_integer_attribute(sort_attribute, sort_direction)
        when :integer
          order_by_integer_attribute(sort_attribute, sort_direction)
        when :string
          order_by_string_attribute(sort_attribute, sort_direction)
        else
          order_by_id_desc
        end
      end

      def order_by_has_many_amount(class_name, sort_direction)
        class_name = class_name.to_s.classify
        has_many_class_names = reflections.collect{|a, b| b.class_name if b.macro==:has_many}.compact
        class_name_association = class_name.downcase.pluralize

        if class_name.in? has_many_class_names
          includes(class_name_association.to_sym)
           .left_joins(class_name_association.to_sym)
           .group(:id)
           .reorder("COUNT(#{class_name_association}.id) #{sort_direction}")
        else
          default_order_by
        end
      end
  end
end
