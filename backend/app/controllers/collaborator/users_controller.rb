# frozen_string_literal: true

class Collaborator::UsersController < Collaborator::CollaboratorController
  def index
    render json: {
      name: current_user.name,
      email: current_user.email,
      start_time: "#{current_user.schedules.last.start_time_hour}H : #{current_user.schedules.last.start_time_minute}min",
      initial_interval: "#{current_user.schedules.last.initial_interval_hour}H #{current_user.schedules.last.initial_interval_minute}min",
      final_interval: "#{current_user.schedules.last.final_interval_hour}H #{current_user.schedules.last.final_interval_minute}min",
      final_time: "#{current_user.schedules.last.final_time_hour}H #{current_user.schedules.last.final_time_minute}min",
      monday: current_user.schedules.last.monday,
      tuesday: current_user.schedules.last.tuesday,
      wednesday: current_user.schedules.last.wednesday,
      thursday: current_user.schedules.last.thursday,
      friday: current_user.schedules.last.friday,
      saturday: current_user.schedules.last.saturday,
      sunday: current_user.schedules.last.sunday
    }
  end
end
