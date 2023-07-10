class Schedule < ApplicationRecord
  belongs_to :role

  has_one :user, through: :role

  validates :closing_date, presence: true
  validates :start_date, presence: true

  validates :start_time_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :start_time_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
  validates :initial_interval_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }, allow_nil: true
  validates :initial_interval_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }, allow_nil: true
  validates :final_interval_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }, allow_nil: true
  validates :final_interval_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }, allow_nil: true
  validates :final_time_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :final_time_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }

  validates :monday, inclusion: { in: [true, false] }
  validates :tuesday, inclusion: { in: [true, false] }
  validates :wednesday, inclusion: { in: [true, false] }
  validates :thursday, inclusion: { in: [true, false] }
  validates :friday, inclusion: { in: [true, false] }
  validates :saturday, inclusion: { in: [true, false] }
  validates :sunday, inclusion: { in: [true, false] }

  validate :check_interval_attributes_presence

  def check_interval_attributes_presence
    if initial_interval_hour.present? || initial_interval_minute.present? || final_interval_hour.present? || final_interval_minute.present?
      if initial_interval_hour.blank? || initial_interval_minute.blank? || final_interval_hour.blank? || final_interval_minute.blank?
        errors.add(:base, "Todos os atributos de intervalo devem estar presentes se qualquer um deles estiver presente.")
      end
    end
  end
end
