class Role < ApplicationRecord
  belongs_to :company
  belongs_to :user

  has_one :schedule, dependent: :destroy
  has_many :point_presences, dependent: :destroy

  has_enumeration_for :role_type, with: RoleEnum::RoleTypes, create_helpers: true
  has_enumeration_for :status, with: RoleEnum::Statuses, create_helpers: true

  validates :role_type, presence: true
  validates :status, presence: true
end
