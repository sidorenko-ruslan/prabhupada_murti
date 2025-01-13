class CreateDiscipleInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :disciple_infos do |t|
      t.string :spritual_name, null: false
      t.string :initiation
      t.string :fullname, null: false
      t.string :address
      t.string :phone
      t.string :email
      t.boolean :imdisciple, default: false
      t.boolean :imgivingcontact, default: false

      t.timestamps
    end
  end
end
