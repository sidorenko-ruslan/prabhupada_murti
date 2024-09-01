class CreateDisciples < ActiveRecord::Migration[7.1]
  def change
    create_table :disciples do |t|
      t.string :name, null: false
      t.string :phone
      t.string :address, null: false
      t.boolean :murti, null: false, default: false

      t.timestamps
    end

    add_reference :orders, :disciple, foreign_key: true
  end
end
