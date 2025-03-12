class AddSpouseFieldsForDiscipleInfos < ActiveRecord::Migration[7.1]
  def change
    add_column :disciple_infos, :imspouse, :boolean, default: false
    add_column :disciple_infos, :spouse_spritual_name, :string
    add_column :disciple_infos, :spouse_initiation, :string
  end
end
