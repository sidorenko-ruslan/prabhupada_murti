class Admin::UsersController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.all.order(created_at: :asc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_root_path
    else
      render "new", status: 422
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update user_params
      redirect_to admin_root_path
    else
      render "edit", status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role_id, :password)
  end
end
