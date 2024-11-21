class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :name
      t.string :email
      t.string :country

      t.timestamps null: false
    end
  end
end
