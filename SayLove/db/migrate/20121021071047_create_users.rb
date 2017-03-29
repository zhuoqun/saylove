class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :avatar
      t.integer :gender
      t.string :password
      t.string :email
      t.boolean :from_provider, :default => true
      t.boolean :disable, :default => false
      t.string :brief
      t.string :password_reset_token
      t.datetime :password_sent_at

      t.timestamps
    end
  end
end
