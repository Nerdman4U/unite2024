class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :topic
      t.text :body
      t.string :email
      t.string :language
      t.string :name

      t.timestamps null: false
    end
  end
end
