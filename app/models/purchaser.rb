class Purchaser < ApplicationRecord
  has_many :orders
  has_many :vendors, through: :orders

  validates :name, presence: true, uniqueness: true
end
