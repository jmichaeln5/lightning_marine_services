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

    private
      def ensure_status
        correlate_status_with_date_delivered
      end

      def correlate_packaging_materials_statuses_with_status
        packaging_material_active_status_names = PackagingMaterial::Statusable::ACTIVE_STATUS_NAMES
        packaging_material_inactive_status_names = PackagingMaterial::Statusable::INACTIVE_STATUS_NAMES

        if status.in? ACTIVE_STATUS_NAMES
          self.packaging_materials.collect { |packaging_material| packaging_material.status = "active" unless self.packaging_material.status.in?(packaging_material_active_status_names) }
        end

        if status.in? INACTIVE_STATUS_NAMES
          packaging_materials.collect { |packaging_material| packaging_material.status = "delivered" unless packaging_material.status.in?(packaging_material_inactive_status_names) }
        end
      end

      def correlate_status_with_date_delivered
        self.date_delivered = Time.now if (status.in?(INACTIVE_STATUS_NAMES) && date_delivered.nil?)
        self.date_delivered = nil if (status.in?(ACTIVE_STATUS_NAMES) && !date_delivered.nil?)
      end
  end
end
