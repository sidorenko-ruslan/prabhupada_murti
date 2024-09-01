require "uri"
require "json"

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
    @sponsor = Sponsor.new
    @manual_count = params[:manual]
    @sponsor.murti_amount = params[:count] if params[:count]
  end

  def become_sponsor
    @sponsor = Sponsor.new(sponsor_params)
    if @sponsor.save
      redirect_to root_path
    else
      render "sponsor", status: 422
    end
  end

  def payment_form
    mrh_login = "giftprabhupada"
    out_sum = "20"
    password_1 = "VYAZIu3AN2exAJ4V3m0i"
    order_id = params[:order_id]
    email = params[:email]
    inv_desc = "Prabhupada Murti"
    hash = {
      sno: "osn",
      items: [
        {name: "Сувенирная статуэтка", quantity: 1, sum: 20, cost: 20, payment_method: "full_payment", payment_object: "commodity", tax: "none"}
      ]
    }
    receipt = JSON.generate(hash)
    receipt = URI.encode_uri_component(receipt)
    signature = Digest::MD5.hexdigest("#{mrh_login}:#{out_sum}:#{order_id}:#{receipt}:#{password_1}")

    @script_src = "https://auth.robokassa.ru/Merchant/PaymentForm/FormMS.js?" \
      "MerchantLogin=#{mrh_login}&" \
      "OutSum=#{out_sum}&" \
      "InvId=#{order_id}&" \
      "Description=#{inv_desc}&" \
      "SignatureValue=#{signature}&" \
      "Email=#{email}&" \
      "Receipt=#{receipt}&" \
      "Culture=ru"

    render "payment_form", layout: false
  end

  def make_purchase
    @order = Order.new(order_params)
    if @order.save
      redirect_to "/payment_form?order_id=#{@order.id}&email=#{@order.email}"
    else
      render "buy", status: 422
    end
  end

  private

  def order_params
    params.require(:order).permit(:client_name, :phone, :email, :address)
  end

  def sponsor_params
    params.require(:sponsor).permit(:name, :phone, :address, :murti_amount, :telegram, :whatsapp)
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
