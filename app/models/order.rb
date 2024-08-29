class Order < ApplicationRecord
  enum :status, [ :not_payed, :payed, :pay_error ]

  validates :client_name, :phone, :email, :address, presence: true
end
