class Admin::OrdersController < ApplicationController
  layout "application_admin"

  before_action :authenticate_user!
end
