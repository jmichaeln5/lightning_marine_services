module OrderContent::Packageables::Describable
  extend ActiveSupport::Concern

  included do
    def without_descriptions
      where(description: [nil, ''])
    end

    def with_descriptions
      where.not(description: [nil, ''])
    end
  end
end
