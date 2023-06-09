# frozen_string_literal: true

class Manager::SchedulesController < UsersController
  def index
    @schedules = Schedule.joins(:role).where(role: { company_id: current_user.role.company_id })

    if params[:user_id].present?
      @schedules = @schedules.joins(:role).where(role: { user_id: params[:user_id] })
    end

    render json: @schedules
  end

  def create
    result = ::Manager::Schedules::Create.result(
      attributes: schedule_params, current_user: current_user
    )

    if result.success?
      render json: result.schedule
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def update
    result = ::Manager::Schedules::Update.result(
      attributes: schedule_params, current_user: current_user
    )

    if result.success?
      render json: result.schedule
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(
      :start_time_hour, :start_time_minute, :initial_interval_hour, :initial_interval_minute,
      :final_interval_hour, :final_interval_minute, :final_time_hour, :final_time_minute,
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday
    ).to_h
  end
end
