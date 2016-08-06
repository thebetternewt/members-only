class User < ApplicationRecord
  attr_accessor :remember_token
  before_create :create_remember_token
  has_secure_password
  has_many :posts

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    create_remember_token
    update_attribute(:remember_digest, User.digest(User.new_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)

  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    def create_remember_token
      self.remember_token = User.new_token
    end

end
