class AddAnonymousToComment < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :anonymous, :boolean
  end
end
