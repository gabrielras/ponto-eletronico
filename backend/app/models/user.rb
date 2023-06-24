require 'jwt'

class User < ApplicationRecord
  has_secure_password

  has_one :role, dependent: :destroy
  has_many :schedules, through: :role

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  def generate_jwt
    encode({ email: self.email, exp: 1.year.from_now.to_i })
  end

  private

  def encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end
end
