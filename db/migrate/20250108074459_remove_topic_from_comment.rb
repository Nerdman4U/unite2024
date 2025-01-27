class RemoveTopicFromComment < ActiveRecord::Migration[8.0]
  def up
    remove_column :comments, :topic
  end
  def down
    add_column :comments, :topic, :string
  end
end
