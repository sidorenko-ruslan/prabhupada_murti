class Admin::DisciplesController < ApplicationController
  layout "application_admin"

  DEFAULT_ORDER = {created_at: :asc}
  
  before_action :authenticate_user!

  def index
    recors_order = params[:filter] ? { params[:filter] => params[:order] } : DEFAULT_ORDER
    @disciples = DiscipleInfo.order(:recors_order)
  end
end
