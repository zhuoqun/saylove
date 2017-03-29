class Notification < ActiveRecord::Base
  attr_accessible :category, :count, :disable, :letter_id, :user_id, :unread, :notified
  # :category => flower/comment

  validates :user_id, :letter_id, :count, :category, :presence => true

  belongs_to :user
end
