class Admin::DisciplesController < ApplicationController
  layout "application_admin"

  DEFAULT_ORDER = {created_at: :asc}
  
  before_action :authenticate_user!

  def index
    recors_order = params[:filter] ? { params[:filter] => params[:order] } : DEFAULT_ORDER
    @discipleInfos = DiscipleInfo.order(recors_order)
  end

  def edit
    @discipleInfo = DiscipleInfo.find(params[:id])
  end

  def update
    @discipleInfo = DiscipleInfo.find(params[:id])
    if @discipleInfo.update disciple_info_params
      redirect_to admin_root_path
    else
      render "edit", status: 422
    end
  end

  def destroy
    discipleInfo = DiscipleInfo.find(params[:id])
    discipleInfo.destroy!

    redirect_to admin_root_path
  end

  private

  def disciple_info_params
    params.require(:disciple_info).permit(:spritual_name, :initiation, :fullname, :address, :phone, :email, :imdisciple, :imgivingcontact, :temple)
  end
end
