module Order::Archivable
  extend ActiveSupport::Concern

  included do
    def self.archived
      where(archived: true)
    end

    def self.unarchived
      where(archived: false)
    end

    private
      def set_archived_value_from_date_delivered?
        return true if from_undelivered_to_delivered?
        return true if to_undelivered_from_delivered?
        return true if date_delivered_changed?

        false
      end

      def from_undelivered_to_delivered?
        date_delivered_changed? && date_delivered_was.nil?
      end

      def to_undelivered_from_delivered?
        date_delivered_changed? && !date_delivered_was.nil?
      end

      def set_archived_value_from_date_delivered
        self.archived = date_delivered.present?
        self.status = "delivered" if date_delivered.present?
        self.status = "active" if !date_delivered.present?
      end
  end
end
