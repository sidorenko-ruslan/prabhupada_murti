class HomeController < ApplicationController
  before_action :set_language

  def index
    @operation_status = params[:operation_status]

    request.variant = browser.device.mobile? ? :mobile : :desktop
  end

  def buy
    @order = Order.new
  end

  def sponsor

  end

  def payment_form
    mrh_login = "giftprabhupada"
    out_sum = "100.00"
    password_1 = "VYAZIu3AN2exAJ4V3m0i"
    order_id = params[:order_id]
    inv_desc = "Prabhupada Murti"
    signature = Digest::MD5.hexdigest("#{mrh_login}:#{out_sum}:#{order_id}:#{password_1}")

    @script_src = "https://auth.robokassa.ru/Merchant/PaymentForm/FormFLS.js?" \
      "MerchantLogin=#{mrh_login}&" \
      "OutSum=#{out_sum}&" \
      "InvId=#{order_id}&" \
      "Description=#{inv_desc}&" \
      "SignatureValue=#{signature}&" \
      "Culture=ru"

    render "payment_form", layout: false
  end

  def make_purchase
    @order = Order.new(order_params)
    if @order.save
      redirect_to "/payment_form?order_id=#{@order.id}"
    else
      render "buy"
    end
  end

  def become_sponsor

  end

  private

  def order_params
    params.require(:order).permit(:client_name, :phone, :email, :address)
  end

  def set_language
    if params[:lang].present?
      cookies.permanent[:lang] = params[:lang]
    end

    lang = cookies[:lang]&.to_sym
    @language = lang == :ru ? "Рус" : "Eng"
    if I18n.available_locales.include?(lang)
      I18n.locale = lang
    end
  end
end
