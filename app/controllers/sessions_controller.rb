class SessionsController < ApplicationController
  skip_before_action :authorized, only: %i[new create]

  def create
    user = User.joins(:client).where(clients: { active: true }).find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in!'
    else
      redirect_to login_path, alert: 'Email or password is invalid'
    end
  end

  def new; end
end
