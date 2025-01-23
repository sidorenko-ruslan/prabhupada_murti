class CreateInitiations < ActiveRecord::Migration[7.1]
  def change
    create_table :initiations do |t|
      t.string :name, null: false
      t.string :place, null: false
      t.string :status
    end

    Initiations.create(name: "Abhaya Devi Dasi", place: "Portland February 1975", status: "")
    Initiations.create(name: "Abhayasraya Dasa", place: "Delhi August 1976", status: "")
    Initiations.create(name: "Abhilasa Dasa", place: "Vrndavana April 1976", status: "")
    Initiations.create(name: "Abhimanyumsi Dasa", place: "London August 1972", status: "")
    Initiations.create(name: "Abhimanyusuta Dasa", place: "Lima September 1977", status: "")
    Initiations.create(name: "Abhinanda Dasa", place: "Seattle August 1973", status: "")
    Initiations.create(name: "Abhinanda Dasa", place: "San Diego 1973", status: "")
    Initiations.create(name: "Abhinanda Dasa", place: "London September 1973", status: "")
    Initiations.create(name: "Abhinava Dasa", place: "Laguna January 1972", status: "")
    Initiations.create(name: "Abhipraya Dasa", place: "Los Angeles June 1974", status: "")
  end
end
