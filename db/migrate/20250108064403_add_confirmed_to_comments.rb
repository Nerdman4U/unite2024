class AddConfirmedToComments < ActiveRecord::Migration[8.0]
  def up
    add_column :comments, :confirmed_at, :datetime, null: true, default: nil
  end

  def down
    remove_column :comments, :confirmed_at
  end
end
