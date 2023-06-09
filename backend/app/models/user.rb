require 'jwt'

class User < ApplicationRecord
  has_secure_password

  has_one :role, dependent: :destroy
  has_one :schedule, through: :role

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def generate_jwt
    encode({ user: self.email, exp: 60.minutes.from_now.to_i })
  end

  private

  def encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end
end
