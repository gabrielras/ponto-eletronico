# frozen_string_literal: true

class Collaborator::PointPresencesController < Collaborator::CollaboratorController
  def index
    @date = params[:data].present? ? Date.parse(params[:data]) : Date.parse(Time.zone.now.to_date.to_s)
    result = ::Collaborator::PointPresences::Search.result(date: @date, user: current_user)
    render json: result.data
  end

  def create
    result = ::Collaborator::PointPresences::Create.result(
      attributes: point_presence_params, user: current_user
    )

    if result.success?
      render json: { status: :created }
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def point_presence_params
    params.permit(
      :schedule_time, :longitude, :latitude, :local_name
    ).to_h
  end
end
