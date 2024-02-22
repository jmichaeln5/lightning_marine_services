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
  include ResourceOrders, ResourceOrders::Sortable

  alias_attribute :purchaser_name, :name
  alias_attribute :ship_name, :name

  has_many :orders
  has_many :vendors, through: :orders
end
