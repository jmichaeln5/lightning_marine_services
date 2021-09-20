class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :purchaser, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true
      t.string :dept
      t.integer :po_number
      t.datetime :date_recieved
      t.string :courrier
      t.datetime :date_delivered
      t.boolean :archived
      t.timestamps
    end
  end
end
