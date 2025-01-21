module Admin::DisciplesHelper
  def disciple_filter_columns
    {
      "id" => "Номер анкеты",
      "spritual_name" => "Духовное имя",
      "initiation" => "Инициация",
      "fullname" => "Ф. И. О.",
      "address" => "Адрес",
      "temple" => "Ближайший центр ИСККОН",
      "phone" => "Телефон",
      "email" => "Имейл",
      "imdisciple" => "Я ученик?",
      "imgivingcontact" => "Я даю контакт на ученика?",
      "created_at" => "Дата создания",
      "updated_at" => "Дата редактирования"
    }
  end

  def disciple_direction(name, filter, disciple)
    return "asc" unless name == filter

    disciple == "asc" ? "desc" : "asc"
  end

  def disciple_arror(name, filter, disciple)
    return "" unless name == filter

    disciple == "asc" ? "bi-arrow-up" : "bi-arrow-down"
  end
end
