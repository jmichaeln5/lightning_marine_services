module Order::Statusable
  extend ActiveSupport::Concern

  included do
    delegate :statuses, :statusable?, to: :class

    STATUSES = %i(active partial hold completed)

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
  end
end
