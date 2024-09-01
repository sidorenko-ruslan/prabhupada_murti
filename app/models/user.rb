class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  belongs_to :role

  validates :name, :email, :password, presence: true

  delegate :admin?, to: :role
end
