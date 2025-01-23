class Initiation < ApplicationRecord
  validates :name, :place, presence: true
end
