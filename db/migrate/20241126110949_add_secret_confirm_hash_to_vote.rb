class AddSecretConfirmHashToVote < ActiveRecord::Migration[8.0]
  def change
    add_column :votes, :secret_confirm_hash, :string
  end
end
