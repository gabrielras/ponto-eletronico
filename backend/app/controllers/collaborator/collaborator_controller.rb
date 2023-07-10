# frozen_string_literal: true

class Collaborator::CollaboratorController < ApplicationController
  before_action :authorization

  private

  def authorization
    return unless current_user.try(:role).try(:manager?)
    head :unauthorized
  end
end
