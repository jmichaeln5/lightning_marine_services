class Vendor < ApplicationRecord
  belongs_to :user
  belongs_to :purchaser

  validates :name, presence: true, uniqueness: true
end
