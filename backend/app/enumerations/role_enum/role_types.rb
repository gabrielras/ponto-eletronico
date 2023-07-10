# frozen_string_literal: true

module RoleEnum
  class RoleTypes < EnumerateIt::Base
    associate_values(:manager, :collaborator_active, :collaborator_banned, :collaborator_pending)
  end
end
