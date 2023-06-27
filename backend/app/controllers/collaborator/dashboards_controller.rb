# frozen_string_literal: true

class Collaborator::DashboardsController < Collaborator::CollaboratorController
  def index
    @year = params[:year].present? ? params[:year].to_i : Time.zone.now.year.to_i
    @month = params[:month].present? ? params[:month].to_i : Time.zone.now.month.to_i

    result = ::Collaborator::PointPresences::Dashboard.result(year: @year, month: @month, user: current_user)
    render json: result.data
  end
end
