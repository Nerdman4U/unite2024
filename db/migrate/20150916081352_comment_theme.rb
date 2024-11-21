class CommentTheme < ActiveRecord::Migration
  def change
    add_column :comments, :theme, :string
  end
end
