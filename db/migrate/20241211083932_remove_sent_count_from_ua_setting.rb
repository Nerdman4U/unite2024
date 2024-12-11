class RemoveSentCountFromUaSetting < ActiveRecord::Migration[8.0]
  def change
    remove_column :ua_settings, :sent_count
  end
end
