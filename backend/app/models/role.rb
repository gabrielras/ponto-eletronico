class Role < ApplicationRecord
  belongs_to :company
  belongs_to :user

  has_many :schedules, dependent: :destroy
  has_many :point_presences, dependent: :destroy

  has_enumeration_for :role_type, with: RoleEnum::RoleTypes, create_helpers: true

  validates :role_type, presence: true
end
