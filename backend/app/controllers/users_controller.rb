class UsersController < ApplicationController
  def update
    result = ::Users::Update.result(user: current_user, attributes: user_params)

    if result.success?
      render json: { status: :ok }, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :name, :authentication_id).to_h
  end
end
