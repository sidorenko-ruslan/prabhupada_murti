class DiscipleInfo < ApplicationRecord
  validates :spritual_name, :fullname, :temple, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
