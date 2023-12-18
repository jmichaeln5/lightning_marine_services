# == Schema Information
#
# Table name: purchasers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Purchaser < ApplicationRecord
  include OrderParent
  has_many :vendors, through: :orders
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
end
