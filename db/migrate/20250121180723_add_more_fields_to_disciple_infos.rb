class AddMoreFieldsToDiscipleInfos < ActiveRecord::Migration[7.1]
  def change
    add_column :disciple_infos, :temple, :string
  end
end
