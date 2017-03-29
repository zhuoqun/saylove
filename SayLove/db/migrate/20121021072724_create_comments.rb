class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user_id
      t.text :content
      t.string :letter_id
      t.boolean :disable, :default => false

      t.timestamps
    end
  end
end
