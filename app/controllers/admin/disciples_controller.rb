class Admin::DisciplesController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!

  def index
    @disciples = DiscipleInfo.all.order(:spritual_name)
  end
end
