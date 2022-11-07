class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authorized

  def hotmart
    if request.headers['X-HOTMART-HOTTOK'] != ENV['HOTTOK']
      return render json: { sucess: false, message: 'Token inválido' },
                    status: :forbidden
    end
    req = JSON.parse(request.body.read, object_class: OpenStruct)
    event_s = req.event

    # TODO passar para constante ENUM
    events = { PURCHASE_CANCELED: 0,
               PURCHASE_APPROVED: 3,
               PURCHASE_PROTEST: 4,
               PURCHASE_REFUNDED: 5,
               PURCHASE_CHARGEBACK: 6,
               PURCHASE_EXPIRED: 7,
               PURCHASE_DELAYED: 8 }

    req.event = events[req.event.to_sym]

    # TODO: Passar responsabilidade para o model
    if req.event == events[:PURCHASE_APPROVED]
      installment = req.data.purchase.payment.installments_number
      if installment > 1
        return render json: { sucess: false, message: "Token já gerado na primeira parcela. Parcela: #{installment}" },
                      status: :ok
      end
      email = req.data.buyer.email

      customer = Customer.new email: email
      customer.save

      payment = Payment.new billing_type: req.data.purchase.payment.type,
                            installment: installment,
                            value: req.data.purchase.price.value,
                            plan: req.data.subscription.plan.name,
                            external_id: req.data.purchase.transaction

      payment.save

      license = License.new key: SecureRandom.uuid, status: :inactive, payment_id: payment.id, customer_id: customer.id
      license.save
      LicenseMailer.send_license(to: email, license: license).deliver_now

      return render json: { sucess: true, message: "Gerado chave #{license.key} para o cliente #{req.data.buyer.email}" },
                    status: :ok
    end

    render json: { sucess: false, message: "Evento não configurado #{event_s}" },
           status: :ok
  end
end
