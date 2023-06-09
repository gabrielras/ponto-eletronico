class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!

  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password]) 
      s = user.generate_jwt
      if !user.active_for_authentication?
        render json: { errors: [ { 'error' => 'Usuário não ativado' } ] }, status: :unauthorized
      else
        render json: { Autorização: s, usuário: user.email, status: :ok }
      end
    else
      render json: { errors: [ { 'error' => 'E-mail ou senha inválidos' } ] }, status: :unauthorized
    end
  end  
end
