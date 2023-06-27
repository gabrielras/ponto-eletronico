class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      role = user.try(:role).try(:role_type) == 'manager' ? 'manager' : 'colab'
      render json: { token: user.generate_jwt, role: role }, status: :ok 
    else
      render json: { errors: [ { 'error' => 'E-mail ou senha inválidos' } ] }, status: :unauthorized
    end
  rescue
    render json: { errors: [ { 'error' => 'E-mail ou senha inválidos' } ] }, status: :unauthorized
  end
end
