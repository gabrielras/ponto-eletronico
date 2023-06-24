# frozen_string_literal: true

module PointPresenceEnum
  class States < EnumerateIt::Base
    associate_values(:adiantado, :atrasado, :pontual)
  end
end
