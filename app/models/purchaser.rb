class Purchaser < ApplicationRecord
  include OrderParent
  has_many :vendors, through: :orders
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
end
