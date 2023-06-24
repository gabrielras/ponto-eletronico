# frozen_string_literal: true

module RoleEnum
  class RoleTypes < EnumerateIt::Base
    associate_values(:manager, :collaborator, :collaborator_pending, :collaborator_active, :collaborator_banned)
  end
end
