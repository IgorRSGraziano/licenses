require 'http'

class Asaas
  attr :host, :token, :req

  def get_customer(customer_id)
    JSON.parse(req.get("#{@host}/customers/#{customer_id}").body, object_class: OpenStruct)
  end

  def change_customer_description(customer_id, description)
    HTTP.post "#{@host}/customers/#{customer_id}", { json: { description => description } }
  end

  def initialize(token)
    @host = if Rails.env.production?
              'https://www.asaas.com/api/v3'
            else
              'https://sandbox.asaas.com/api/v3'
            end

    @token = token
    @req = HTTP.headers(access_token: @token)
  end
end
