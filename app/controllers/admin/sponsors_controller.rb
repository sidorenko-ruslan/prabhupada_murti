class Admin::SponsorsController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!

  def index
    @sponsors = Sponsor.all.order(created_at: :desc)
  end
end
