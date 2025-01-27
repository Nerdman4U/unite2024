class ChangeAnonymousAtComments < ActiveRecord::Migration[8.0]
  def down
    change_column :comments, :anonymous, :boolean, default: nil
  end

  def up
    change_column :comments, :anonymous, :boolean, default: true
  end
end
