class CreateUaSettings < ActiveRecord::Migration
  def change
    create_table :ua_settings do |t|
      t.timestamp :sent_at
      t.integer :vote_count
      t.integer :sent_count

      t.timestamps null: false
    end
  end
end
