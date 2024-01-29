module Order::Statusable
  extend ActiveSupport::Concern

  STATUS_NAMES = %i(active partially_delivered delivered hold)
  ACTIVE_STATUS_NAMES = %i(active partially_delivered hold)
  INACTIVE_STATUS_NAMES = STATUS_NAMES - ACTIVE_STATUS_NAMES

  included do
    delegate :statusable?, to: :class

    delegate :statuses, to: :class
    delegate :active_statuses, :inactive_statuses, to: :class
    delegate :status_names, :active_status_names, :inactive_status_names, to: :class

    enum status: %i(active partially_delivered delivered hold)

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

    def self.all_inactive
      where(status: INACTIVE_STATUS_NAMES)
    end

    def self.all_active
      where.not(status: INACTIVE_STATUS_NAMES)
    end

    def statusable_type
      model_name.name
    end

    def statusable_id
      id
    end

    def statusable_dom_id
      "status_#{model_name.element}_#{id}"
    end

    def edit_statusable_dom_id
      "edit_status_#{model_name.element}_#{id}"
    end
  end
end
