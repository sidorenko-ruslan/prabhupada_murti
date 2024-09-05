class Order < ApplicationRecord
  enum :status, [ :not_payed, :payed, :pay_error ]

  belongs_to :disciple, optional: true

  validates :client_name, :phone, :email, :address, :murti_count, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
