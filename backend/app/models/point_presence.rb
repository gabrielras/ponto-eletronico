class PointPresence < ApplicationRecord
  belongs_to :role

  has_enumeration_for :schedule_time, with: PointPresenceEnum::ScheduleTimes, create_helpers: true

  validates :date, presence: true
  validates :geocoding, presence: true
  validates :schedule_time, presence: true

  validate :schedule_time_unique_day
  
  private

  def schedule_time_unique_day
    return unless Role.where(schedule_time: schedule_time)
                  .where(:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).present?

    errors.add(:schedule_time, "Mensagem de erro personalizada")
  end
end
