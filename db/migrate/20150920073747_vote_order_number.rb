class VoteOrderNumber < ActiveRecord::Migration
  def change
    add_column :votes, :order_number, :integer
  end
end
