class AddResourcePerPageToTableOptions < ActiveRecord::Migration[6.1]
  def change
    add_column :table_options, :resources_per_page, :integer, :null => false, :default => 10
  end
end
