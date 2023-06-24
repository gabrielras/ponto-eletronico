require 'jwt'

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do |e|
    flash[:error] = e.message

    if session[:current_fullpath] == session[:return_to]
      redirect_to(root_path)
    else
      redirect_to(session[:return_to] || root_path)
    end
  end

  def return_location
    session[:return_to] = request.fullpath if request.get? || request.head?
    session[:current_fullpath] = request.fullpath
  end

  private

  def authenticate_user!
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ').last
        jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
        @current_user = User.find_by_email(jwt_payload.first['email'])
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    else
      head :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
