# frozen_string_literal: true

class Manager::UsersController < Manager::ManagerController
  before_action :set_user, except: [:create, :index]

  def index
    @users = User.joins(:role).where.not(role: { role_type: 'manager' }).where(role: { company_id: current_user.role.company_id }).all
    render json: @users
  end

  def create
    result = ::Manager::Users::Create.result(attributes: user_params, user: current_user)

    if result.success?
      render json: {}, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def update
    result = ::Manager::Users::Update.result(attributes: user_params, user: @user)

    if result.success?
      render json: {}, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def destroy
    result = ::Manager::Users::Destroy.result(user: @user)

    if result.success?
      render json: {}, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(
      :email, :start_time_hour, :start_time_minute, :initial_interval_hour, :initial_interval_minute,
      :final_interval_hour, :final_interval_minute, :final_time_hour, :final_time_minute,
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday
    ).to_h
  end

  def set_user
    @user = User.joins(:role).where.not(role: {role_type: 'manager'}).where(role: {company_id: current_user.role.company_id }).find(params[:id])
  end
end