# frozen_string_literal: true

class Manager::ManagerController < ApplicationController
  before_action :authorization

  private

  def authorization
    return if current_user.role.manager?
    head :unauthorized
  end
end