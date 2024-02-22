module PackagingMaterial::Statusable
  extend ActiveSupport::Concern

  STATUS_NAMES          = Order::Statusable::STATUS_NAMES - ["partially_delivered"]
  ACTIVE_STATUS_NAMES   = Order::Statusable::ACTIVE_STATUS_NAMES - ["partially_delivered"]
  INACTIVE_STATUS_NAMES = STATUS_NAMES - ACTIVE_STATUS_NAMES

  included do
    delegate :statusable?, to: :class
    delegate :statuses, to: :class
    delegate :status_names, :active_status_names, :inactive_status_names, to: :class
    delegate :active_statuses, :inactive_statuses, to: :class

    enum status: ((_statuses = Order.statuses.dup); _statuses.delete(:partially_delivered); _statuses)

    STATUSES = self.statuses
    ACTIVE_STATUSES = (_statuses = self.statuses.dup); _statuses.delete(:delivered); _statuses
    INACTIVE_STATUSES = self.statuses.slice(:delivered)

    def self.statusable?
      true
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

    def statusable_type
      model_name.name
    end

    def statusable_id
      id
    end

    def statusable_path
      "#{Rails.application.routes.url_helpers.orders_path}/#{order_content.order_id}"
    end

    def statusable_dom_id
      "status_packaging_material_#{model_name.element}_#{id}"
    end

    def edit_statusable_dom_id
      "edit_status_packaging_material_#{model_name.element}_#{id}"
    end
  end
end
