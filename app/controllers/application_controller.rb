class ApplicationController < ActionController::Base

  @@crypt = ActiveSupport::MessageEncryptor.new(ENV['CRYPT_KEY'])

  helper_method :current_user
  before_action :authorized
  helper_method :logged_in?

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to login_path unless logged_in?
  end
end
