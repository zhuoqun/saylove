class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :user_id
      t.string :provider
      t.string :uid
      t.string :url
      t.string :token

      t.timestamps
    end
  end
end
