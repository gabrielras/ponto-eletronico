# frozen_string_literal: true

class Manager::UserController < Manager::ManagerController
  def index
    render json: {
      id: current_user.id.to_s,
      name: current_user.name,
      email: current_user.email,
      company_name: current_user.role.company.name
    }
  end
end
