class Vendor < ApplicationRecord
  has_many :orders
  has_many :purchasers, through: :orders

  validates :name, presence: true, uniqueness: true
end
