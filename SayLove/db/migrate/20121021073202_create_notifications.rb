class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :user_id
      t.string :letter_id
      t.string :category
      t.integer :count, :default => 0
      t.boolean :unread, :default => true
      t.boolean :notified, :default => false
      t.boolean :disable, :default => false

      t.timestamps
    end
  end
end
