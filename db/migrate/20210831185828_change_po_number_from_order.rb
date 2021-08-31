class ChangePoNumberFromOrder < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :po_number, :string, unique: true
  end
end
