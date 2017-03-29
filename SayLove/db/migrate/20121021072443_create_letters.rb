class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.string :user_id
      t.string :contact_id
      t.string :contact_type
      t.text :content
      t.integer :flowers_cnt, :default => 0
      t.boolean :is_public, :default => false
      t.boolean :comments_on, :default => false
      t.boolean :is_draft, :default => false
      t.boolean :is_viewed, :default => false
      t.boolean :notified, :default => false
      t.boolean :has_echo, :default => false
      t.boolean :disable, :default => false

      t.timestamps
    end
  end
end
