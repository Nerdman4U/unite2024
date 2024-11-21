class CreateVoteCounts < ActiveRecord::Migration
  def change
    create_table :vote_counts do |t|
      t.string :country
      t.integer :count

      t.timestamps null: false
    end
  end
end
