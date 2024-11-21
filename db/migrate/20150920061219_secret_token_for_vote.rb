class SecretTokenForVote < ActiveRecord::Migration
  def change
    add_column :votes, :secret_token, :string
  end
end
