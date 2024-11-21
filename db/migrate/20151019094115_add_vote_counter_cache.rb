class AddVoteCounterCache < ActiveRecord::Migration
  def change
    add_column :votes, :votes_count, :integer
  end
end
