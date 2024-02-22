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
  include ResourceOrders, ResourceOrders::Sortable

  alias_attribute :vendor_name, :name

  has_many :orders
  has_many :purchasers, through: :orders
end
