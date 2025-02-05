class DiscipleInfo < ApplicationRecord
  validates :spritual_name, :fullname, :temple, :street, :zip, :city, :country, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
