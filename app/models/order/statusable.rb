module Order::Statusable
  extend ActiveSupport::Concern

  included do
    delegate :statusable?, to: :class

    STATUSES = %i(active partial hold completed)

    enum status: STATUSES

    def self.statusable?
      true
    end
  end
end
