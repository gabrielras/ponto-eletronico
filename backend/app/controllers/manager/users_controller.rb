# frozen_string_literal: true

class Manager::UsersController < UsersController
  before_action :set_user

  def index
    @users = User.joins(:role).where(role: { id: current_user.role.id }).all
    render json: @users
  end

  def create
    result = ::Manager::Roles::Create.result(
      attributes: role_params, current_user: current_user
    )

    if result.success?
      render json: result.role
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def update
    result = ::Manager::Roles::Update.result(
      attributes: role_params, current_user: current_user
    )

    if result.success?
      render json: result.role
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def role_params
    params.require(:role).permit(:role_type, :status).to_h
  end

  def set_role
    @role = Role.where(company: current_user.role.company).find(params[:id])
  end
end