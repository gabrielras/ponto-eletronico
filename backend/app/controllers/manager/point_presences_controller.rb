# frozen_string_literal: true

class Manager::PointPresencesController < UsersController
  before_action :point_presence

  def index
    @point_presences = PointPresence.joins(:role)
                                    .where(role: { company_id: current_user.role.company_id })
                                    .all
    if params[:data].present?
      @date = Date.parse(params[:data])
      @point_presences = @point_presences.where(:created_at => @date.beginning_of_day..@date.end_of_day)
    end

    render json: @point_presences
  end
end
