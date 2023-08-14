module Attachable::Images
  extend ActiveSupport::Concern
  
  included do
    has_many_attached :images
  end
end
