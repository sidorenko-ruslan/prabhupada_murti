class Order < ApplicationRecord
  validates :client_name, :phone, :email, :address, presence: true
end
