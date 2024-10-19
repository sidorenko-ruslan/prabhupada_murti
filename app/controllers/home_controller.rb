require "uri"
require "json"

class HomeController < ApplicationController
  before_action :set_language

  def index
    @operation_status = params[:operation_status]
    @main_video = main_video_url
    @achievements_video = achievements_video_url
    cookies[:lang] = params[:lang]

    request.variant = browser.device.mobile? ? :mobile : :desktop
  end

  def buy
    @order = Order.new
    @order.client_name = cookies[:client_name]
    @order.phone = cookies[:phone]
    @order.email = cookies[:email]
    @order.address = cookies[:address]
    @order.murti_count = params[:murti_count]
  end

  def make_purchase
    @order = find_previous_unpayed_order
    @order.address = order_params[:address] if @order
    @order ||= Order.new(order_params)
    cookies[:client_name] = @order.client_name
    cookies[:phone] = @order.phone
    cookies[:email] = @order.email
    cookies[:address] = @order.address

    if @order.save
      redirect_to "/payment_form?order_id=#{@order.id}&email=#{@order.email}&murti_count=#{@order.murti_count}&lang=#{cookies[:lang]}"
    else
      render "buy", status: 422
    end
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
    murti_count = params[:murti_count].to_i
    order_id = params[:order_id]
    email = params[:email]
    lang = params[:lang]

    murti_price = locale_price(lang)
    out_sum = murti_price * murti_count
    password_1 = "VYAZIu3AN2exAJ4V3m0i"
    inv_desc = "Prabhupada Murti"
    hash = {
      sno: "usn_income",
      items: [
        {name: "Сувенирная статуэтка", quantity: murti_count, sum: out_sum, cost: murti_price, payment_method: "full_payment", payment_object: "commodity", tax: "none"}
      ]
    }
    receipt = URI.encode_uri_component(JSON.generate(hash))
    receipt2 = URI.encode_uri_component(receipt)
    signature = Digest::MD5.hexdigest("#{mrh_login}:#{out_sum}:#{order_id}:#{receipt}:#{password_1}")

    @script_src = "https://auth.robokassa.ru/Merchant/PaymentForm/FormMS.js?" \
      "MerchantLogin=#{mrh_login}&" \
      "OutSum=#{out_sum}&" \
      "InvId=#{order_id}&" \
      "Description=#{inv_desc}&" \
      "SignatureValue=#{signature}&" \
      "Email=#{email}&" \
      "Receipt=#{receipt2}&" \
      "Culture=#{lang}"

    render "payment_form", layout: false
  end

  private

  def main_video_url
    params[:lang] == "en" ? "https://www.youtube.com/embed/Y5f27LOze0s" : "https://www.youtube.com/embed/jfpb7slIhEk"
  end

  def achievements_video_url
    params[:lang] == "en" ? "https://www.youtube.com/embed/--01Ltg6qpk?controls=0&modestbranding=0" : "https://www.youtube.com/embed/KwDTI3tGnO8?controls=0&modestbranding=0"
  end

  def locale_price(lang)
    lang == "en" ? 13500 : 10800
  end

  def order_params
    params.require(:order).permit(:client_name, :phone, :email, :address, :murti_count)
  end

  def sponsor_params
    params.require(:sponsor).permit(:name, :phone, :address, :murti_amount, :telegram, :whatsapp)
  end

  def find_previous_unpayed_order
    Order.find_by(client_name: order_params[:client_name],
      email: order_params[:email],
      phone: order_params[:phone],
      murti_count: order_params[:murti_count],
      status: [:not_payed, :pay_error])
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
