# frozen_string_literal: true

module PointPresenceEnum
  class ScheduleTimes < EnumerateIt::Base
    associate_values(:start_time, :initial_interval, :final_interval, :final_time)
  end
end
