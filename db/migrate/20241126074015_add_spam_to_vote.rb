class AddSpamToVote < ActiveRecord::Migration[8.0]
  def change
    add_column :votes, :spam, :boolean, default: false, null: false
  end
end
