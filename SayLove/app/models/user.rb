class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add(attribute, options[:message], options)
    end
  end
end

class User < ActiveRecord::Base
  attr_accessible :avatar, :brief, :disable, :from_provider, :gender, :password, :password_reset_token, :password_sent_at, :user_name, :email

  after_create :create_email_options

  validates :user_name, :from_provider, :presence => true
  validates :email, :allow_blank => true, :uniqueness => { :case_sensitive => false }, :email => { :message => :invalid_email}

  has_one  :provider
  has_one  :email_option
  has_many :comments
  has_many :letters
  has_many :flowers
  has_many :favorites
  has_many :notifications

  private

  def create_email_options
    option = EmailOption.new
    option.user_id = self.id
    option.save
  end

end
