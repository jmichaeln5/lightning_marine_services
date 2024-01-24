module Order::Filterable
  extend ActiveSupport::Concern

  included do
    def self.filterable_attrs
      %w(id status dept courrier)
    end
  end

  module ClassMethods
    def filter(filtering_params)
      filters = Hash.new
      filtering_params.collect {|key, value| (filters[key] = value) if key.in?(filterable_attrs)}

      where(filters)
    end
  end
end
