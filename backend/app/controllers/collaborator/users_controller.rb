# frozen_string_literal: true

class Collaborator::UsersController < Collaborator::CollaboratorController
  def index
    render json:  {
      id: current_user.try(:id).to_s,
      name: current_user.try(:name),
      email: current_user.try(:email),
      authentication_id: current_user.try(:authentication_id),
      company_name: current_user.try(:role).try(:company).try(:name),
      role_active: (current_user.try(:role).blank? || current_user.try(:role).try(:role_type) == 'collaborator_pending') ? false : true,
      start_time: "#{current_user.try(:schedules).try(:last).try(:start_time_hour)}:#{current_user.try(:schedules).try(:last).try(:start_time_minute)}",
      initial_interval: "#{current_user.try(:schedules).try(:last).try(:initial_interval_hour)}:#{current_user.try(:schedules).try(:last).try(:initial_interval_minute)}",
      final_interval: "#{current_user.try(:schedules).try(:last).try(:final_interval_hour)}:#{current_user.try(:schedules).try(:last).try(:final_interval_minute)}",
      final_time: "#{current_user.try(:schedules).try(:last).try(:final_time_hour)}:#{current_user.try(:schedules).try(:last).try(:final_time_minute)}",
      monday: current_user.try(:schedules).try(:last).try(:monday),
      tuesday: current_user.try(:schedules).try(:last).try(:tuesday),
      wednesday: current_user.try(:schedules).try(:last).try(:wednesday),
      thursday: current_user.try(:schedules).try(:last).try(:thursday),
      friday: current_user.try(:schedules).try(:last).try(:friday),
      saturday: current_user.try(:schedules).try(:last).try(:saturday),
      sunday: current_user.try(:schedules).try(:last).try(:sunday)
    }
  end

  def accept
    result = ::Collaborator::Users::Accept.result(user: current_user)

    if result.success?
      render json: { status: :created }
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def reject
    result = ::Collaborator::Users::Reject.result(user: current_user)

    if result.success?
      render json: { status: :created }
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end
end
