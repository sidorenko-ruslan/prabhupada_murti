class Role < ApplicationRecord
  def admin?
    name == "Админ"
  end
end
