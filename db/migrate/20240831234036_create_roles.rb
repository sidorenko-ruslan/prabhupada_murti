class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.timestamps
    end

    Role.create(name: "Админ")
    Role.create(name: "Пользователь")
  end
end
