require 'jwt'

module JwtModule
  def self.authenticate_token(token)
    decoded_token = JWT.decode(token, Rails.application.config.jwt_secret)
    decoded_token.first
  end

  def self.generate_token(payload)
    JWT.encode(payload, Rails.application.config.jwt_secret)
  end
end
