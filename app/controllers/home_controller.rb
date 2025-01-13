require "uri"
require "json"

class HomeController < ApplicationController
  before_action :set_language

  def index
    @operation_status = params[:operation_status]
    @main_video = main_video_url
    @achievements_video = achievements_video_url
    cookies[:lang] ||= params[:lang]

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

  def disciple
    @discipleInfo = DiscipleInfo.new
  end
  
  def add_disciple
    
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
    @language = lang

    murti_price_ru = locale_price("ru")
    murti_price_en = locale_price("en")
    out_sum_ru = murti_price_ru * murti_count
    out_sum_en = murti_price_en * murti_count
    password_1 = "VYAZIu3AN2exAJ4V3m0i"
    inv_desc = "Prabhupada Murti"
    hash_ru = {
      sno: "usn_income",
      items: [
        {name: "Сувенирная статуэтка", quantity: murti_count, sum: out_sum_ru, cost: murti_price_ru, payment_method: "full_payment", payment_object: "commodity", tax: "none"}
      ]
    }
    hash_en = {
      sno: "usn_income",
      items: [
        {name: "Souvenir figurine", quantity: murti_count, sum: out_sum_en, cost: murti_price_en, payment_method: "full_payment", payment_object: "commodity", tax: "none"}
      ]
    }
    receipt_ru = URI.encode_uri_component(JSON.generate(hash_ru))
    receipt2_ru = URI.encode_uri_component(receipt_ru)

    receipt_en = URI.encode_uri_component(JSON.generate(hash_en))
    receipt2_en = URI.encode_uri_component(receipt_en)

    signature_ru = Digest::MD5.hexdigest("#{mrh_login}:#{out_sum_ru}:#{order_id}:#{receipt_ru}:#{password_1}")
    signature_en = Digest::MD5.hexdigest("#{mrh_login}:#{out_sum_en}:#{order_id}:#{receipt_en}:#{password_1}")


    @script_src_ru = "https://auth.robokassa.ru/Merchant/PaymentForm/FormMS.js?" \
      "MerchantLogin=#{mrh_login}&" \
      "OutSum=#{out_sum_ru}&" \
      "InvId=#{order_id}&" \
      "Description=#{inv_desc}&" \
      "SignatureValue=#{signature_ru}&" \
      "Email=#{email}&" \
      "Receipt=#{receipt2_ru}&" \
      "Culture=ru"

    @script_src_en = "https://auth.robokassa.ru/Merchant/PaymentForm/FormMS.js?" \
      "MerchantLogin=#{mrh_login}&" \
      "OutSum=#{out_sum_en}&" \
      "InvId=#{order_id}&" \
      "Description=#{inv_desc}&" \
      "SignatureValue=#{signature_en}&" \
      "Email=#{email}&" \
      "Receipt=#{receipt2_en}&" \
      "Culture=en"

    render "payment_form", layout: false
  end

  private

  def main_video_url
    cookies[:lang].to_s == "en" ? "https://www.youtube.com/embed/Y5f27LOze0s" : "https://www.youtube.com/embed/jfpb7slIhEk"
  end

  def achievements_video_url
    cookies[:lang].to_s == "en" ? "https://www.youtube.com/embed/--01Ltg6qpk?controls=0&modestbranding=0" : "https://www.youtube.com/embed/KwDTI3tGnO8?controls=0&modestbranding=0"
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

  def best_locale_from_request
    return I18n.default_locale unless request.headers.key?("HTTP_ACCEPT_LANGUAGE")

    string = request.headers.fetch("HTTP_ACCEPT_LANGUAGE")
    locale = AcceptLanguage.parse(string).match(*I18n.available_locales)

    return I18n.default_locale if locale.nil?

    locale
  end

  def set_language
    lang = params[:lang]&.to_sym || cookies[:lang]&.to_sym || best_locale_from_request
    cookies.permanent[:lang] = lang
    @language = lang == :ru ? "Рус" : "Eng"
    if I18n.available_locales.include?(lang)
      I18n.locale = lang
    end
  end
end
