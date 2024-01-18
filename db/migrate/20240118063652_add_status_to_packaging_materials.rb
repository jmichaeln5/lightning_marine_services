class AddStatusToPackagingMaterials < ActiveRecord::Migration[6.1]
  def up
    add_column :packaging_materials, :status, :integer, default: 0

    add_index :packaging_materials, %i(status)
  end

  def down
    remove_column(:packaging_materials, :status, if_exists: true)
  end
end
