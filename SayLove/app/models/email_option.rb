class EmailOption < ActiveRecord::Base
  attr_accessible :comment, :echo, :flower, :user_id

  validates :user_id, :presence => true

  belongs_to :user
end
