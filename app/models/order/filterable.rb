module Order::Filterable
  extend ActiveSupport::Concern

  included do
    def self.filterable_attrs
      %w(status dept courrier)
    end
  end


  module ClassMethods
    # def filter(filtering_params)
    #   results = self.where(nil)
    #   filtering_params.each do |key, value|
    #     results = results.public_send("filter_by_#{key}", value) if value.present?
    #   end
    #   results
    # end

    def filter(filtering_params)
      results = self.where(nil)

      filters = Hash.new
      filtering_params.collect {|key, value| (filters[key] = value) if key.in?(filterable_attrs)}

      results = where(filters)
      results
    end

  end
end
