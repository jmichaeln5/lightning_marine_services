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
  alias_attribute :purchaser_name, :name
  alias_attribute :ship_name, :name

  include ResourceOrders

  has_many :vendors, through: :orders
end
