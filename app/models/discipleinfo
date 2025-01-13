class Discipleinfo < ApplicationRecord
  validates :spritual_name, :fullname, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
