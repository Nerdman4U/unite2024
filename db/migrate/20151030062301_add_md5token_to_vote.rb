class AddMd5tokenToVote < ActiveRecord::Migration
  def change
    add_column :votes, :md5_secret_token, :string
  end
end
