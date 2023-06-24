class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password]) 
      render json: { token: user.generate_jwt }, status: :ok 
    else
      render json: { errors: [ { 'error' => 'E-mail ou senha inválidos' } ] }, status: :unauthorized
    end
  rescue
    render json: { errors: [ { 'error' => 'E-mail ou senha inválidos' } ] }, status: :unauthorized
  end
end
