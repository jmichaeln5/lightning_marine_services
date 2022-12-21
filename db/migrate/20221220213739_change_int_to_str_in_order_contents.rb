class ChangeIntToStrInOrderContents < ActiveRecord::Migration[6.1]
  def change
    change_column :order_contents, :box, :string
    change_column :order_contents, :crate, :string
    change_column :order_contents, :pallet, :string
    change_column :order_contents, :other, :string
  end
end
