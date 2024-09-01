class Admin::OrdersController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!
  before_action :require_admin, only: [:edit, :update]

  def index
    @orders = Order.all.order(created_at: :desc)
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.new(order_params)
    if @order.save
      redirect_to admin_root_path
    else
      render "edit", status: 422
    end
  end

  private

  def order_params
    params.require(:order).permit(:client_name, :phone, :email, :address)
  end
end
