class LicensesController < ApplicationController
  before_action :set_license, only: %i[show edit update destroy change_status]
  before_action :set_license_key, only: %i[activate]
  skip_before_action :authorized, only: %i[activate status inactivate]
  skip_before_action :verify_authenticity_token, only: %i[activate status inactivate create]
  before_action :admin_action, except: %i[index activate inactivate status]

  # GET /licenses or /licenses.json
  def index
    @clients_options = Client.pluck(:brand, :id);
    @licenses = License.left_joins(:payment).where('`key` LIKE ?', "%#{params[:q]}%").order(
      params[:sort] ||= 'licenses.created_at DESC'
    ).page(params[:page])
  end

  # GET /licenses/1 or /licenses/1.json
  def show; end

  # GET /licenses/new
  def new
    @license = License.new
  end

  # GET /licenses/1/edit
  def edit
    @customers_options = Customer.all.pluck :email, :id
  end

  # GET /licenses/import
  def import
    @clients_options = Client.all.pluck :brand, :id
  end

  # POST /licenses/import
  def import_create
    data = params[:licenses]
    licenses = data.split(';')
    licenses.each do |license|
      License.create key: license.strip, status: :inactive, client_id: params[:client_id]
    end

    redirect_to licenses_import_path, notice: 'Licenses were successfully imported.'
  end

  # POST /licenses or /licenses.json
  def create
    data = request.body.read.blank? ? nil : JSON.parse(request.body.read, object_class: OpenStruct)

    @license = License.new key: SecureRandom.uuid, status: :inactive, client_id: data.whitelabel

    respond_to do |format|
      if @license.save
        format.html { redirect_to licenses_path, notice: "License #{@license.key} was successfully created." }
        format.json { render :show, status: :created, location: @license }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /licenses/change_status
  def change_status
    status = License.statuses[@license.status]
    next_status = License.statuses.invert[status.to_i + 1 == License.statuses.size ? 0 : status.to_i + 1]
    @license.update(status: next_status)

    redirect_to licenses_path, notice: 'License status was successfully changed.'
  end

  # PUT /licenses/activate
  def activate
    return render json: { succes: false, message: 'Licença não encontrada.' }, status: :ok if @license.nil?
    return render json: { succes: false, message: 'Licença expirada!' }, status: :ok unless @license.inactive?

    crypt = ActiveSupport::MessageEncryptor.new(ENV['CRYPT_KEY'])
    token = crypt.encrypt_and_sign(@license.key)

    @license.update(status: :active)
    render json: { succes: 'true', message: 'Licença ativada com sucesso!', token: }, status: :ok
  end

  # PUT /licenses/inactivate
  def inactivate
    data = request.body.read.blank? ? nil : JSON.parse(request.body.read, object_class: OpenStruct)
    license = from_token(data[:token])
    return render json: { succes: false, message: 'Licença não encontrada.' }, status: :ok if license.nil?
    return render json: { succes: false, message: 'Licença expirada!' }, status: :ok unless license.active?

    license.update(status: :inactive)

    render json: { succes: true, message: 'Licença inativada.' }, status: :ok
  end

  # GET /license/status/:key
  def status
    license = from_token(params[:key]) || License.find_by(key: params[:key])
    return render json: { active: false, message: 'Licença não encontrada.' }, status: :ok if license.nil?
    return render json: { active: false, message: 'Licença expirada!' }, status: :ok unless license.active?

    render json: { active: true, message: 'Licença válida.' }, status: :ok
  end

  # PATCH/PUT /licenses/1 or /licenses/1.json
  def update
    respond_to do |format|
      if @license.update(license_params)
        format.html { redirect_to license_url(@license), notice: 'License was successfully updated.' }
        format.json { render :show, status: :ok, location: @license }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses/1 or /licenses/1.json
  def destroy
    @license.destroy

    respond_to do |format|
      format.html { redirect_to licenses_url, notice: 'License was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_license
    @license = License.find(params[:id])
  end

  def set_license_key
    data = request.body.read.blank? ? nil : JSON.parse(request.body.read, object_class: OpenStruct)
    @license = License.find_by(key: data[:key])
  end

  # Only allow a list of trusted parameters through.
  def license_params
    params.require(:license).permit(:key, :status, :customer_id)
  end

  # TODO: Passar isso para o Model
  def from_token(token)
    token = token.gsub ' ', '+'
    crypt = ActiveSupport::MessageEncryptor.new(ENV['CRYPT_KEY'])
    key = crypt.decrypt_and_verify(token)
    License.find_by(key: key)
  rescue
    nil
  end
end
