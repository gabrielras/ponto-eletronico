class RegistrationsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!

  def create
    u = User.new(user_params)
    if u.save
      render json: { status: :created }
    else
      render json: { errors: u.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
