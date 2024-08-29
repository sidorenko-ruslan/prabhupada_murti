class Admin::OrdersController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!

  def index
    @orders = Order.all.order(created_at: :desc)
  end
end
