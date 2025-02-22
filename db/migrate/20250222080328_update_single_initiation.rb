class UpdateSingleInitiation < ActiveRecord::Migration[7.1]
  def change
    Initiation.where(name: "Acyutananda Dasa").update_all(status: "Delivered")
  end
end
