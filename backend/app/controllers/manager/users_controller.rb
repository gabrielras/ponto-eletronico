# frozen_string_literal: true

class Manager::UsersController < Manager::ManagerController
  before_action :set_user, except: [:create, :index]

  def index
    @users = User.joins(:role).where.not(role: { role_type: 'manager' }).where(role: { company_id: current_user.role.company_id, role_type: ['collaborator_active', 'collaborator_pending'] }).all
    @users = @users.where('name ILIKE ?', "%#{params[:name]}%") if params[:name].present?
    @users = @users.where(id: params[:id]) if params[:id].present?
    render json: users_info(@users)
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

  def reset
    result = ::Manager::Users::Reset.result(user: @user)

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

  def user_info(user)
    {
      id: user.id.to_s,
      name: user.name,
      email: user.email,
      authentication_id: user.authentication_id,
      company_name: user.role.company.name,
      start_time_hour: user.schedules.last.start_time_hour,
      start_time_minute: user.schedules.last.start_time_minute,
      initial_interval_hour: user.schedules.last.initial_interval_hour,
      initial_interval_minute: user.schedules.last.initial_interval_minute,
      final_interval_hour: user.schedules.last.final_interval_hour,
      final_interval_minute: user.schedules.last.final_interval_minute,
      final_time_hour: user.schedules.last.final_time_hour,
      final_time_minute: user.schedules.last.final_time_minute,
      monday: user.schedules.last.monday,
      tuesday: user.schedules.last.tuesday,
      wednesday: user.schedules.last.wednesday,
      thursday: user.schedules.last.thursday,
      friday: user.schedules.last.friday,
      saturday: user.schedules.last.saturday,
      sunday: user.schedules.last.sunday
    }
  end

  def users_info(users)
    users.map { |user| user_info(user) }
  end
end