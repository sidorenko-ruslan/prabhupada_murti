class Sponsor < ApplicationRecord
  validates :name, :phone, :address, :murti_amount, presence: true
end
