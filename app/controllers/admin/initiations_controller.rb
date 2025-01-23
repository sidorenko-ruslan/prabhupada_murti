class Admin::InitiationsController < ApplicationController
  layout "application_admin"

  DEFAULT_ORDER = {id: :asc}
  
  before_action :authenticate_user!

  def new
    @initiation = Initiation.new
  end

  def create
    @initiation = Initiation.new(initiation_params)
    if @initiation.save
      redirect_to admin_initiations_path
    else
      render "new", status: 422
    end
  end
  
  def index
    recors_order = params[:filter] ? { params[:filter] => params[:order] } : DEFAULT_ORDER
    @initiations = Initiation.order(recors_order)
  end

  def edit
    @initiation = Initiation.find(params[:id])
  end

  def update
    @initiation = Initiation.find(params[:id])
    if @initiation.update initiation_params
      redirect_to admin_initiations_path
    else
      render "edit", status: 422
    end
  end

  def destroy
    initiation = Initiation.find(params[:id])
    initiation.destroy!

    redirect_to admin_initiations_path
  end

  private

  def initiation_params
    params.require(:initiation).permit(:name, :place, :status)
  end
end
