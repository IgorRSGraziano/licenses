class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authorized
  before_action :set_client

  def hotmart
    if @client.nil?
      return render json: { sucess: false, message: 'Cliente não identificado' },
                    status: :forbidden
    end

    if request.headers['X-HOTMART-HOTTOK'] != @client.param('HOTTOK').value(@client.id)
      return render json: { sucess: false, message: 'Token inválido' },
                    status: :forbidden
    end
    req = JSON.parse(request.body.read, object_class: OpenStruct)
    event_s = req.event

    events = { PURCHASE_CANCELED: 0,
               PURCHASE_COMPLETE: 1,
               PURCHASE_BILLET_PRINTED: 2,
               PURCHASE_APPROVED: 3,
               PURCHASE_PROTEST: 4,
               PURCHASE_REFUNDED: 5,
               PURCHASE_CHARGEBACK: 6,
               PURCHASE_EXPIRED: 7,
               PURCHASE_DELAYED: 8 }

    buy_events = [events[:PURCHASE_COMPLETE], events[:PURCHASE_APPROVED]]
    cancel_events = [events[:PURCHASE_CANCELED],
                     events[:PURCHASE_PROTEST],
                     events[:PURCHASE_REFUNDED],
                     events[:PURCHASE_CHARGEBACK],
                     events[:PURCHASE_EXPIRED],
                     events[:PURCHASE_DELAYED]]

    req.event = events[req.event.to_sym]

    # TODO: Passar responsabilidade para o model
    if buy_events.include?(req.event)
      installment = req.data.purchase.payment.installments_number
      if installment > 1
        return render json: { sucess: false, message: "Token já gerado na primeira parcela. Parcela: #{installment}" },
                      status: :ok
      end
      email = req.data.buyer.email

      customer = Customer.new email: email, client_id: @client.id
      customer.save

      paymentIntegration = PaymentIntegration.find_by identifier: 'HOTMART'

      payment = Payment.new billing_type: req.data.purchase.payment.type,
                            installment: installment,
                            value: req.data.purchase.price.value,
                            plan: req.data.subscription.plan.name,
                            external_id: req.data.purchase.transaction,
                            payment_integration_id: paymentIntegration.id

      payment.save

      license = License.new key: SecureRandom.uuid, status: :inactive, payment_id: payment.id,
                            customer_id: customer.id, client_id: @client.id
      license.save
      LicenseMailer.send_license(to: email, license: license, client: @client).deliver_now

      return render json: { sucess: true, message: "Gerado chave #{license.key} para o cliente #{req.data.buyer.email}" },
                    status: :ok
    elsif cancel_events.include?(req.event)
      license = Payment.find_by(external_id: req.data.purchase.transaction).license
      license.status = :suspended
      license.save
      LicenseMailer.cancel_license(to: req.data.buyer.email, license: license, brand: @client.brand).deliver_now!

      return render json: { sucess: true,
                            message: "Licença #{license.key} cancelada para o cliente #{req.data.buyer.email}" }
    end

    render json: { sucess: false, message: "Evento não configurado #{event_s}" },
           status: :ok

  rescue => e
    render json: { sucess: false, message: e.message, stacktrace: e.backtrace }, status: :internal_server_error

  end

  def asaas
    if @client.nil?
      return render json: { sucess: false, message: 'Cliente não identificado' },
                    status: :forbidden
    end
    charge = JSON.parse(request.body.read, object_class: OpenStruct)
    # TODO: Criar parametro de asaas acces token
    if request.headers['asaas-access-token'] != @client.param('ASAAS_ACCESS_TOKEN').value(@client.id)
      return render json: { sucess: false, message: 'Token inválido' },
                    status: :forbidden
    end
    nonPaymentStatus = %w[PAYMENT_REFUNDED PAYMENT_OVERDUE PAYMENT_DUNNING_REQUESTED]
    paymentStatus = %w[PAYMENT_CONFIRMED PAYMENT_RECEIVED]

    if charge.event == 'PAYMENT_RECEIVED' && charge.payment.billingType == 'CREDIT_CARD'
      return render json: { succes: false, message: 'Licença não gerada, pagamento recebido, licença foi gerada na confirmação' }
    end

    asaas_service = Asaas.new(@client.param('ASAAS_AUTH_TOKEN').value(@client.id))

    if paymentStatus.include? charge.event
      unless charge.payment.paymentLink
        return render json: { succes: false, message: 'Compra não foi gerado por link de pagamento' }
      end
      if charge.payment.installmentNumber > 1
        return render json: { succes: false, message: 'Pagamento parcelado, token gerado na primeira parcela.' }
      end

      links = Link.where client_id: @client.id

      unless links.any? { |l| URI(l.link).path.split('/').last == charge.payment.paymentLink }
        return render json: { succes: false, message: 'Link de pagamento não configurado' }
      end

      asaas_customer = asaas_service.get_customer charge.payment.customer
      customer = Customer.new name: asaas_customer.name, email: asaas_customer.email, phone: asaas_customer.mobilePhone,
                              external_id: asaas_customer.id, client_id: @client.id
      customer.save

      paymentIntegration = PaymentIntegration.find_by identifier: 'ASAAS'

      payment = Payment.new billing_type: charge.payment.billingType,
                            # installment: charge.payment.installmentNumber,
                            # value: req.data.purchase.price.value,
                            # plan: req.data.subscription.plan.name,
                            external_id: charge.payment.id,
                            payment_integration_id: paymentIntegration.id

      license = License.new key: SecureRandom.uuid, status: :inactive, payment_id: payment.id,
                            customer_id: customer.id, client_id: @client.id
      license.save
      LicenseMailer.send_license(to: customer.email, license: license, client: @client).deliver_now

      return render json: { sucess: true, message: "Gerado chave #{license.key} para o cliente #{customer.email}" },
                    status: :ok
    elsif nonPaymentStatus.include? charge.event
      license = Payment.find_by(external_id: charge.payment.id).license
      customer = license.customer
      license.update status: :suspended

      LicenseMailer.cancel_license(to: customer.email, license: license, brand: @client.brand).deliver_now!

      return render json: { sucess: true,
                            message: "Licença #{license.key} cancelada para o cliente #{customer.email}" }
    end

    render json: { sucess: false, message: "Evento não configurado" },
           status: :ok
  rescue => e
    render json: { sucess: false, message: e.message, stacktrace: e.backtrace }, status: :internal_server_error
  end

  private

  def set_client
    @client = Client.find_by(token: params[:client_token])
  end
end
