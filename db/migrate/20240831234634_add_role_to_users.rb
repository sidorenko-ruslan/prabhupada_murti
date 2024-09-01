class AddRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    User.delete_all

    add_column :users, :name, :string, null: false
    add_reference :users, :role, null: false, foreign_key: true

    User.create(name: "Руслан", email: "sidoruss@gmail.com", password: "j3qq4h7h2v", role_id: 1)
  end
end
