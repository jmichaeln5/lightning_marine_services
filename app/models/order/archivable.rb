module Order::Archivable
  extend ActiveSupport::Concern

  included do
    def self.archived
      where(archived: true)
    end

    def self.unarchived
      where(archived: false)
    end

    def previously_became_archived?
      (archived_previously_was == true) && (archived_was == false)
    end

    def previously_became_unarchived?
      (archived_previously_was == false) && (archived_was == true)
    end
  end
end
