class CreateEmailOptions < ActiveRecord::Migration
  def change
    create_table :email_options do |t|
      t.string  :user_id
      t.boolean :echo, :default => true
      t.boolean :flower, :default => false
      t.boolean :comment, :default => false

      t.timestamps
    end
  end
end
