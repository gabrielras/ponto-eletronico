class RegistrationsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!

  def create
    result = ::Users::Create.result(attributes: user_params)
    if result.success?
      render json: { status: :created }
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :company_name, :role_type).to_h
  end
end
