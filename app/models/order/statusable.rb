module Order::Statusable
  extend ActiveSupport::Concern

  STATUSES = %i(active partially_delivered delivered hold archived)

  included do
    delegate :statuses, :statusable?, to: :class

    enum status: STATUSES

    def self.statuses
      STATUSES
    end

    def self.statusable?
      true
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
