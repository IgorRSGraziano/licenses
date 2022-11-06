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
      mail = req.data.buyer.email
      prod = Rails.env.production? ? 1 : 2
      test = Rails.env.production? ? mail : ENV['SMTP_TEST_TO']
      key = License.new(key: SecureRandom.uuid, status: :inactive).save
      LicenseMailer.send_license(to: req.data.buyer.email).deliver_now
    end

    render json: { sucess: false, message: "Evento não configurado #{event_s}" },
           status: :ok
  end
end
