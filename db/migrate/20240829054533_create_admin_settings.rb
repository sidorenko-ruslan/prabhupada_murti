class CreateAdminSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_settings do |t|

      t.timestamps
    end
  end
end
