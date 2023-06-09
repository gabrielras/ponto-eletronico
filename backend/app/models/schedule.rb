class Schedule < ApplicationRecord
  belongs_to :role

  validates :start_time_hour, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 24 }
  validates :start_time_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
  validates :initial_interval_hour, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 24 }
  validates :initial_interval_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
  validates :final_interval_hour, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 24 }
  validates :final_interval_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
  validates :final_time_hour, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 24 }
  validates :final_time_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }

  validates :monday, inclusion: { in: [true, false] }
  validates :tuesday, inclusion: { in: [true, false] }
  validates :wednesday, inclusion: { in: [true, false] }
  validates :thursday, inclusion: { in: [true, false] }
  validates :friday, inclusion: { in: [true, false] }
  validates :saturday, inclusion: { in: [true, false] }
  validates :sunday, inclusion: { in: [true, false] }
end
