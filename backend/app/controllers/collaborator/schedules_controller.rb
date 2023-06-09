# frozen_string_literal: true

class Collaborator::SchedulesController < UsersController
  def index
    @schedule = current_user.role.schedule
    render json: @schedule
  end
end
