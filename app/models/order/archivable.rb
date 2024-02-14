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
      def set_archived_value?
        date_delivered_changed? || new_record?
      end

      def set_archived_value
        self.archived = date_delivered.present?
      end
  end
end
