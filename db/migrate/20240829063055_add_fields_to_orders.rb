class AddFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_sum, :string
    add_column :orders, :payment_fee, :string
    add_column :orders, :payment_method, :string
  end
end
