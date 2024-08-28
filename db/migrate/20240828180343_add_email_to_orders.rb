class AddEmailToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :email, :string, null: false
    change_column_default :orders, :status, 0
  end
end
