json.extract! payment, :id, :type, :external_id, :installment, :value, :plan, :created_at, :updated_at
json.url payment_url(payment, format: :json)
