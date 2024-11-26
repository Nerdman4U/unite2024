class AddEmailConfirmedToVote < ActiveRecord::Migration[8.0]
  def change
    add_column :votes, :email_confirmed, :datetime
  end
end
