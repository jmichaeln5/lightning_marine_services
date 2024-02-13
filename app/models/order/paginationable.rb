module Order::Paginationable # should be in decorators, not models and not under models/order/
  extend ActiveSupport::Concern

  included do
    def next_record
      self.class.where('id > ?', id).first
    end

    def next_record?
      self.class.where('id > ?', id).exists?
    end

    def previous_record
      self.class.where('id < ?', id).last
    end

    def previous_record?
      self.class.where('id < ?', id).exists?
    end
  end
end
