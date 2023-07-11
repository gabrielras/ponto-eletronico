class PointPresence < ApplicationRecord
  belongs_to :role

  has_enumeration_for :schedule_time, with: PointPresenceEnum::ScheduleTimes, create_helpers: true
  has_enumeration_for :state, with: PointPresenceEnum::States, create_helpers: true

  validates :longitude, presence: true
  validates :latitude, presence: true
  validates :local_name, presence: true
  validates :schedule_time, presence: true
  validates :state, presence: true
end
