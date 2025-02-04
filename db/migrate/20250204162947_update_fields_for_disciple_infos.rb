class UpdateFieldsForDiscipleInfos < ActiveRecord::Migration[7.1]
  def change
    remove_column :disciple_infos, :address
    add_column :disciple_infos, :street, :string
    add_column :disciple_infos, :zip, :string
    add_column :disciple_infos, :city, :string
    add_column :disciple_infos, :state, :string
    add_column :disciple_infos, :country, :string
  end
end
