class Provider < ActiveRecord::Base
  attr_accessible :provider, :token, :uid, :url, :user_id

  validates :user_id, :uid, :url, :presence => true

  belongs_to :user
end
