class ApplicationController < ActionController::Base

  helper_method :current_user
  before_action :authorized
  helper_method :logged_in?

  def current_user
    User.joins(:client).where(clients: { active: true }).find_by_id(session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to login_path unless logged_in?
  end
end
