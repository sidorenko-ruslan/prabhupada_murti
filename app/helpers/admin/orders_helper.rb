module Admin::OrdersHelper
  def order_filter_columns
    {
      "id" => "Номер заказа",
      "client_name" => "Имя заказчика",
      "phone" => "Телефон",
      "email" => "Почта",
      "murti_count" => "Количество мурти",
      "payment_sum" => "Оплаченная сумма",
      "payment_fee" => "Комиссия",
      "payment_method" => "Способ оплаты",
      "address" => "Адрес доставки",
      "track_number" => "Трек номер посылки",
      "comment" => "Комментарий к заказу",
      "disciples.name" => "Ученик ШП",
      "created_at" => "Дата создания",
      "updated_at" => "Дата редактирования",
      "status" => "Статус"
    }
  end

  def order_direction(name, filter, order)
    return "asc" unless name == filter

    order == "asc" ? "desc" : "asc"
  end

  def order_arror(name, filter, order)
    return "" unless name == filter

    order == "asc" ? "bi-arrow-up" : "bi-arrow-down"
  end
end
