module Order::Statusable
  extend ActiveSupport::Concern

  STATUS_NAMES = %w(active partially_delivered delivered hold)
  ACTIVE_STATUS_NAMES = %w(active partially_delivered hold)
  INACTIVE_STATUS_NAMES = STATUS_NAMES - ACTIVE_STATUS_NAMES

  included do
    delegate :statusable?, to: :class

    delegate :statuses, to: :class
    delegate :active_statuses, :inactive_statuses, to: :class
    delegate :status_names, :active_status_names, :inactive_status_names, to: :class

    enum status: %i(active partially_delivered delivered hold)

    STATUSES = self.statuses
    ACTIVE_STATUSES = (_active_statuses = self.statuses.dup); _active_statuses.delete(:delivered); _active_statuses
    INACTIVE_STATUSES = self.statuses.slice(:delivered)

    def self.statusable?
      true
    end

    def self.status_names
      STATUS_NAMES
    end

    def self.active_status_names
      ACTIVE_STATUS_NAMES.collect {|status_name| status_name.to_s }
    end

    def self.inactive_status_names
      INACTIVE_STATUS_NAMES.collect {|status_name| status_name.to_s }
    end

    def self.active_statuses
      statuses.select {|_status| _status if _status.in?  ACTIVE_STATUS_NAMES.collect {|status| status.to_s } }
    end

    def self.inactive_statuses
      statuses.select {|_status| _status unless _status.in?  ACTIVE_STATUS_NAMES.collect {|status| status.to_s } }
    end

    def self.active
      where(status: active_statuses.keys)
    end

    def self.inactive
      where(status: inactive_statuses.keys)
    end

    def self.completed
      where(status: "delivered")
    end

    def statusable_type
      model_name.name
    end

    def statusable_id
      id
    end

    def statusable_path
      "#{Rails.application.routes.url_helpers.orders_path}/#{id}"
    end

    def statusable_dom_id
      "status_#{model_name.element}_#{id}"
    end

    def edit_statusable_dom_id
      "edit_status_#{model_name.element}_#{id}"
    end

    private
      def self.deliver_active
        all.each do |order|
          order.delivered!
          order.save
        end
      end

      def set_associated_statuses_from_order?
        status_changed?
      end

      def set_associated_statuses_from_order
        if hold?
          set_associated_statuses_from_order_status_hold
        else
          set_associated_statuses_from_order_status_active_or_delivered if set_associated_statuses_from_order_status_active_or_delivered?
        end
      end

      def set_associated_statuses_from_order_status_active_or_delivered?
        return false unless status_changed?

        (should_set_associate_boolean = !status.in?(active_status_names)) if status_was.in?(active_status_names)
        (should_set_associate_boolean = !status.in?(inactive_status_names)) if status_was.in?(inactive_status_names)
        should_set_associate_boolean
      end

      def get_date_delivered_from_status(order_status: status)
        order_status.in?(active_status_names) ? nil : DateTime.now
      end

      def get_archived_from_status(order_status: status)
        order_status.in?(active_status_names) ? false : true
      end

      def set_associated_statuses_from_order_status_hold
        order_content_attributes = order_content.packaging_materials_attributes_pair
        order_content_attributes_dup = order_content_attributes.dup
        order_content_attributes = order_content_attributes_dup[:order_content_attributes][0]

        order_content_attributes_dup[:packaging_materials_attributes].collect { |packaging_material|
          (packaging_material["status"] = "hold") unless (packaging_material["status"] == "hold")
        }
        order_content_attributes[:packaging_materials_attributes] = order_content_attributes_dup[:packaging_materials_attributes]

        assign_attributes(
          {
            status: "hold",
            date_delivered: get_date_delivered_from_status(order_status: "hold"),
            archived: get_archived_from_status(order_status: "hold"),
            order_content_attributes: order_content_attributes,
          }
        )
      end

      def set_associated_statuses_from_order_status_active_or_delivered(order_status: status)
        order_content_attributes = order_content.packaging_materials_attributes_pair
        order_content_attributes_dup = order_content_attributes.dup
        order_content_attributes = order_content_attributes_dup[:order_content_attributes][0]

        valid_packaging_material_status_names = order_status.in?(active_status_names) ? PackagingMaterial.active_status_names : PackagingMaterial.inactive_status_names

        modified_packaging_material_status = order_status.in?(active_status_names) ? "active" : "delivered"

        order_content_attributes_dup[:packaging_materials_attributes].collect { |pm|
          (pm["status"] = modified_packaging_material_status) unless pm["status"].in?(valid_packaging_material_status_names)
        }
        order_content_attributes[:packaging_materials_attributes] = order_content_attributes_dup[:packaging_materials_attributes]

        assign_attributes(
          {
            status: order_status,
            date_delivered: get_date_delivered_from_status(order_status: order_status),
            archived: get_archived_from_status(order_status: order_status),
            order_content_attributes: order_content_attributes,
          }
        )
      end
  end
end
