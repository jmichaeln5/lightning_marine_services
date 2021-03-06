class CreateOrderContents < ActiveRecord::Migration[6.1]
  def change
    create_table :order_contents do |t|
      t.integer :box
      t.integer :crate
      t.integer :pallet
      t.integer :other
      t.text :other_description
      t.belongs_to :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
