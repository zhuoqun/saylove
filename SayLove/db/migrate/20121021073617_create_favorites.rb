class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :user_id
      t.string :letter_id
      t.boolean :disable, :default => false

      t.timestamps
    end
  end
end
