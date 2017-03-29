class Flower < ActiveRecord::Base
  attr_accessible :disable, :letter_id, :user_id

  after_save :add_flowers_count

  validates :user_id, :letter_id, :presence => true

  belongs_to :user
  belongs_to :letter

  def add_flowers_count
    letter = self.letter
    letter.flowers_cnt += 1
    letter.save
  end
end
