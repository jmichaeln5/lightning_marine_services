class CreateTableOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :table_options do |t|
      t.string :resource_table_type
      t.text :option_list
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
