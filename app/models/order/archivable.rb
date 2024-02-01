module Order::Archivable
  extend ActiveSupport::Concern

  included do
    def self.archived
      where(archived: true)
    end

    def self.unarchived
      where(archived: false)
    end
  end
end
