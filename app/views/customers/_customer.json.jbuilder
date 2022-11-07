json.extract! customer, :id, :name, :email, :phone, :description, :external_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)
