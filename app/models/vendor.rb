class Vendor < ApplicationRecord
  include OrderParent  #  has_many :orders
  has_many :purchasers, through: :orders
  # searchkick
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
end
