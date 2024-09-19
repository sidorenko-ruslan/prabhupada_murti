class Admin::OrdersController < ApplicationController
  layout "application_admin"

  DEFAULT_ORDER = {created_at: :asc}

  before_action :authenticate_user!

  def index
    recors_order = params[:filter] ? { params[:filter] => params[:order] } : DEFAULT_ORDER
    @orders = Order.includes(:disciple).order(recors_order)
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update order_params
      redirect_to admin_root_path
    else
      render "edit", status: 422
    end
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy! unless order.payed?

    redirect_to admin_root_path
  end

  private

  def order_params
    params.require(:order).permit(:client_name, :phone, :email, :address, :track_number, :disciple_id, :comment)
  end
end
