class CreateDisciple < ActiveRecord::Migration[7.1]
  def change
    create_table :disciples do |t|
      t.string :spritual_name
      t.string :initiation
      t.string :fullname
      t.string :address
      t.string :phone
      t.string :email
      t.boolean :imdisciple
      t.boolean :imgivingcontact

      t.timestamps
    end
  end
end
