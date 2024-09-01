class Disciple < ApplicationRecord
  validates :name, :address, presence: true
end
