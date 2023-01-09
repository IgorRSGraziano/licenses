class UserController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      sessions[:user_id] = @user.id
      redirect_to '/welcome'
    else
      redirect_to '/login'
    end
  end

  def edit
    @parameters = Parameter.all
  end

  def update
    @user.update user_params
    @user.client.update brand: params[:brand]

    ParametersHelper.update_by_client current_user.client_id, params
  end

  private

  def user_params
    params.permit(:email, :password, :username)
  end

  def set_user
    @user = current_user
  end
end
