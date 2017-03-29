class Comment < ActiveRecord::Base
  attr_accessible :content, :disable, :letter_id, :user_id

  validates :user_id, :letter_id, :presence => true
  validates :content, :presence => true

  belongs_to :user
  belongs_to :letter
end
