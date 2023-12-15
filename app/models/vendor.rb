class Vendor < ApplicationRecord
  include OrderParent
  has_many :purchasers, through: :orders
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
end
