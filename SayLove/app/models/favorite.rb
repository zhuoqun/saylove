class Favorite < ActiveRecord::Base
  attr_accessible :disable, :letter_id, :user_id

  validates :user_id, :letter_id, :presence => true

  belongs_to :user
  belongs_to :letter
end
