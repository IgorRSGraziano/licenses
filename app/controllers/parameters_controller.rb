class ParametersController < ApplicationController
  before_action :set_parameter, only: %i[ show edit update destroy ]

  # GET /parameters or /parameters.json
  def index
    @parameters = Parameter.all
  end

  # GET /parameters/1 or /parameters/1.json
  def show
  end

  # GET /parameters/new
  def new
    @parameter = Parameter.new
  end

  # GET /parameters/1/edit
  def edit
  end

  # POST /parameters or /parameters.json
  def create
    @parameter = Parameter.new(parameter_params)

    respond_to do |format|
      if @parameter.save
        format.html { redirect_to parameter_url(@parameter), notice: "Parameter was successfully created." }
        format.json { render :show, status: :created, location: @parameter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parameters/1 or /parameters/1.json
  def update
    respond_to do |format|
      if @parameter.update(parameter_params)
        format.html { redirect_to parameter_url(@parameter), notice: "Parameter was successfully updated." }
        format.json { render :show, status: :ok, location: @parameter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parameters/1 or /parameters/1.json
  def destroy
    @parameter.destroy

    respond_to do |format|
      format.html { redirect_to parameters_url, notice: "Parameter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parameter
      @parameter = Parameter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parameter_params
      params.require(:parameter).permit(:identifier, :name, :description)
    end
end
