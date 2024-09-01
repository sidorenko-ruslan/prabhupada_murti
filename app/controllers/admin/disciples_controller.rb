class Admin::DisciplesController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!

  def index
    @disciples = Disciple.all.order(:name)
  end
end
