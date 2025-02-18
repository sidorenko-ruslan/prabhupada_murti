class Admin::DisciplesController < ApplicationController
  layout "application_admin"

  DEFAULT_ORDER = {created_at: :asc}
  
  before_action :authenticate_user!

  def index
    recors_order = params[:filter] ? { params[:filter] => params[:order] } : DEFAULT_ORDER
    @disciples = DiscipleInfo.order(recors_order)
  end

  def edit
    @disciple = DiscipleInfo.find(params[:id])
  end

  def update
    @disciple = DiscipleInfo.find(params[:id])
    if @disciple.update disciple_info_params
      redirect_to admin_disciples_path
    else
      render "edit", status: 422
    end
  end

  def destroy
    disciple = DiscipleInfo.find(params[:id])
    disciple.destroy!

    redirect_to admin_disciples_path
  end

  private

  def disciple_info_params
    params.require(:disciple_info).permit(:spritual_name, :initiation, :fullname, :street, :zip, :city, :state, :country, :phone, :email, :imdisciple, :imgivingcontact, :temple, :comment)
  end
end
