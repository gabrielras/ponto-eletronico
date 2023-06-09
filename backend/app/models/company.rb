class Company < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
