# frozen_string_literal: true
class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]
  before_action :admin_action

  # GET /clients or /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1 or /clients/1.json
  def show; end

  # GET /clients/new
  def new
    @client = Client.new
    @parameters = Parameter.all
    @client.users.build if @client.users.blank?
  end

  # GET /clients/1/edit
  def edit
    @parameters = Parameter.all
  end

  # POST /clients or /clients.json
  def create
    @client = Client.new client_params
    @client.token = SecureRandom.hex(10)
    # @user = User.new client_params


    respond_to do |format|
      if @client.save
        ParametersHelper.update_by_client @client.id, params[:client]
        format.html { redirect_to edit_client_url(@client), notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        ParametersHelper.update_by_client @client.id, params[:client]
        format.html { redirect_to edit_client_url(@client), notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:client).permit(:brand, :description, users_attributes: %i[email password])
  end
end
