class HomeController < ApplicationController
  before_action :set_language

  def index
    request.variant = browser.device.mobile? ? :mobile : :desktop
  end

  def set_language
    if params[:lang].present?
      cookies.permanent[:lang] = params[:lang]
    end

    lang = cookies[:lang]&.to_sym
    if I18n.available_locales.include?(lang)
      I18n.locale = lang
    end
  end
end
