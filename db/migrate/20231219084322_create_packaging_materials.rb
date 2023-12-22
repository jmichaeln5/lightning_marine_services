class CreatePackagingMaterials < ActiveRecord::Migration[6.1]
  def up
    create_table :packaging_materials do |t|
      t.references :order_content, null: false, foreign_key: true
      t.string :type
      t.text :description

      t.timestamps
    end
    add_index :packaging_materials, [:type]
  end

  def down
    drop_table :packaging_materials
  end
end
