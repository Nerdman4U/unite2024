class RemoveCommentNameAndEmail < ActiveRecord::Migration
  def change
    remove_column :comments, :name
    remove_column :comments, :email
  end
end
