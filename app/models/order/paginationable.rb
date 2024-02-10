module Order::Paginationable
  extend ActiveSupport::Concern

  included do
    def next_order
      self.class.where('id > ?', id).first
    end

    def prev_order
      self.class.where('id < ?', id).last
    end
  end
end
