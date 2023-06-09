# frozen_string_literal: true

class Collaborator::PointPresencesController < UsersController
  def index
    @date = params[:data].present? ? Time.zone.now : Date.parse(params[:data])
    @point_presences = PointPresence.where(role_id: current_user.role_id)
                                    .where(:created_at => @date.beginning_of_day..@date.end_of_day)
                                    .all
    render json: @point_presences
  end

  def create
    result = ::Manager::PointPresences::Create.result(
      attributes: point_presence_params, current_user: current_user
    )

    if result.success?
      render json: { status: :created }
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def point_presence_params
    params.require(:point_presence).permit(
      :schedule_time, :date, :geocoding, :authentication
    ).to_h
  end
end
