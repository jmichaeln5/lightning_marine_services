class Order < ApplicationRecord
  belongs_to :purchaser
  belongs_to :vendor
  
  has_many :order_contents
end
