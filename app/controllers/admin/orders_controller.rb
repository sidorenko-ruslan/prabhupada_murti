class Admin::OrdersController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!
  before_action :require_admin, only: [:edit, :update]

  def index
    @orders = Order.includes(:disciple).order(created_at: :desc)
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
