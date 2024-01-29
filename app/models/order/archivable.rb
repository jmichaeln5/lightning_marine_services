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
      def ensure_archived_val
        self.archived = date_delivered.present? ? true : false
      end

      def ensure_archived_val?
        archived != date_delivered.present?
      end
  end
end
