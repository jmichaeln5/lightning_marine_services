module Order::Deliverable
  extend ActiveSupport::Concern

  included do
    private
      def set_status_from_date_delivered?
        became_undelivered? || became_delivered?
      end

      def set_status_from_date_delivered
        self.status = "delivered" if became_delivered?
        self.status = "active" if became_undelivered?
      end

      def became_undelivered?
        !date_delivered? && !date_delivered_was.nil?
      end

      def became_delivered?
        date_delivered_was.nil? && date_delivered?
      end
  end
end
