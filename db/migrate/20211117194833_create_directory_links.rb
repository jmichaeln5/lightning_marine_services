class CreateDirectoryLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :directory_links do |t|
      t.string :title
      t.string :link
      t.text :desc
      t.string :info

      t.timestamps
    end
  end
end
