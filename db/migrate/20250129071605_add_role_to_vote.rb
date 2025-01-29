class AddRoleToVote < ActiveRecord::Migration[8.0]
  def change
    add_column :votes, :role, :string
  end
end
