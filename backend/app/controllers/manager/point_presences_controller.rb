# frozen_string_literal: true

class Manager::PointPresencesController < Manager::ManagerController
  def index
    @date = params[:data].present? ? Date.parse(params[:data]) : Date.parse(Time.zone.now.to_date.to_s)
    result = ::Manager::PointPresences::Search.result(date: @date, user: current_user)
    render json: result.data
  end
end
