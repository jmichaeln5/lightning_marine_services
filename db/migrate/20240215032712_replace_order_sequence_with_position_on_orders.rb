class ReplaceOrderSequenceWithPositionOnOrders < ActiveRecord::Migration[6.1]
  def set_orders_column_values(from:, to:)
    orders = Order.all

    total_orders_amount = orders.size
    orders_amount = total_orders_amount.dup

    Order.reindex
    Order.search_index.delete

    Order.all.each do |order|
      order[to] = order.send(from)
      order.save(validate: false)

      orders_amount -= 1
      puts "\n\n#{orders_amount}/#{total_orders_amount} remaining.\n\n"
    end
    Order.reindex
  end

  def up
    add_column :orders, :position, :integer, default: 1
    set_orders_column_values(from: :order_sequence, to: :position)
    remove_column(:orders, :order_sequence, if_exists: true)
  end

  def down
    add_column :orders, :order_sequence, :integer
    set_orders_column_values(from: :position, to: :order_sequence)
    remove_column(:orders, :position, if_exists: true)
  end
end
