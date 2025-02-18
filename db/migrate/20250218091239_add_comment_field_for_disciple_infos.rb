class AddCommentFieldForDiscipleInfos < ActiveRecord::Migration[7.1]
  def change
    add_column :disciple_infos, :comment, :string
  end
end
