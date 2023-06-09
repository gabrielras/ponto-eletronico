# frozen_string_literal: true

class Collaborator::CollaboratorController < ApplicationController
  before_action :authorization

  private

  def authorization
    return if current_user.role.collaborator?
    head :unauthorized
  end
end