class AddOrderSequenceToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :order_sequence ,:integer
  end
end
