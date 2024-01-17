class AddStatusToOrders < ActiveRecord::Migration[6.1]
  def up
    add_column :orders, :status, :integer, default: 0

    add_index :orders, %i(status)
  end

  def down
    remove_column(:orders, :status, if_exists: true)
  end
end
