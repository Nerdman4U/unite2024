class AddSlugsToComment < ActiveRecord::Migration[8.1]
  def up
    add_column :comments, :slug, :string, null: false
    add_index :comments, :slug
  end

  def down
    remove_index :comments, :slug
    remove_column :comments, :slug
  end
end
