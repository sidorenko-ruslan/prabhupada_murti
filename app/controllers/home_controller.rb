class HomeController < ApplicationController
  before_action :set_language

  def index
    request.variant = browser.device.mobile? ? :mobile : :desktop
  end

  def buy

  end

  def sponsor

  end

  def make_purchase

  end

  def become_sponsor

  end

  private

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
