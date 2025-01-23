module Admin::InitiationsHelper
  def initiation_filter_columns
    {
      "id" => "Номер",
      "name" => "Духовное имя",
      "place" => "Место, время",
      "status" => "Статус"
    }
  end

  def initiation_direction(name, filter, initiation)
    return "asc" unless name == filter

    initiation == "asc" ? "desc" : "asc"
  end

  def initiation_arror(name, filter, initiation)
    return "" unless name == filter

    initiation == "asc" ? "bi-arrow-up" : "bi-arrow-down"
  end
end
