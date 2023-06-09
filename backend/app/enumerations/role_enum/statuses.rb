# frozen_string_literal: true

module RoleEnum
  class Statuses < EnumerateIt::Base
    associate_values(:pending, :active, :banned)
  end
end
