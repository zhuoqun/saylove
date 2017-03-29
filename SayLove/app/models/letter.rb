class Letter < ActiveRecord::Base
  attr_accessible :comments_on, :contact_id, :contact_type, :content, :disable, :is_draft, :is_public, :is_viewed, :notified, :user_id, :has_echo, :flowers_cnt

  before_save :check_echos

  validates :user_id, :contact_id, :contact_type, :content, :presence => true

  default_scope where('letters.disable = ?', false)
  scope :recent_letters, where('is_public = ?', true).order('created_at DESC')
  scope :hot_letters, where('is_public = ?', true).order('flowers_cnt DESC, created_at DESC')

  belongs_to :user
  has_many :comments
  has_many :flowers
  has_many :favorites

  def self.favorited_by_user_id(user_id)
    joins(:favorites).where('favorites.user_id' => user_id).order('favorites.created_at DESC')
  end

  def self.echo_letters_by_user(user)
    where('contact_type' => user.provider.provider, 'contact_id' => user.provider.uid, 'has_echo' => true).order('created_at DESC')
  end

  def self.unread_echo_letters_by_user(user)
    where('contact_type' => user.provider.provider, 'contact_id' => user.provider.uid, 'has_echo' => true, 'is_viewed' => false).count
  end

  def check_echos
    current_user = User.find(user_id)
    echo_user = User.joins(:provider).where('providers.uid' => contact_id, 'providers.provider' => contact_type)
    if echo_user.present?
      echo_letters = echo_user.first.letters.where('contact_id' => current_user.provider.uid, 'contact_type' => current_user.provider.provider)
      if echo_letters.present?
        self.has_echo = true

        echo_letters.update_all(:has_echo => true)
      end
    end
  end
end
