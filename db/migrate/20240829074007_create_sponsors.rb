class CreateSponsors < ActiveRecord::Migration[7.1]
  def change
    create_table :sponsors do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.integer :murti_amount, null: false
      t.boolean :telegram, default: false, null: false
      t.boolean :whatsapp, default: false, null: false

      t.timestamps
    end
  end
end
