class AddMoreFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :comment, :string
    add_column :orders, :murti_count, :integer, null: false, default: 1
  end
end
