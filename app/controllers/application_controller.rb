class ApplicationController < ActionController::Base
  class AuthenticationError < StandardError
  end

  rescue_from 'AuthenticationError', with: :deny_access

  private

  def require_admin
    raise AuthenticationError unless current_user.admin?
  end

  def deny_access
    head :forbidden
  end
end
