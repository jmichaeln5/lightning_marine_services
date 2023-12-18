# == Schema Information
#
# Table name: vendors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Vendor < ApplicationRecord
  include OrderParent
  has_many :purchasers, through: :orders
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
end
