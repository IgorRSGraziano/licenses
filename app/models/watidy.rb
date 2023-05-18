require 'http'

class Watidy
  attr :token

  def send_message(number, message)
    number_send = Rails.env.production? ? number : ENV['NOTIFY_NUMBER']
    encoded = CGI.escape(message)
    HTTP.get("https://api.touswhatsapp.com.br/send/#{@token}/?cmd=chat&to=#{number_send}@c.us&msg=#{encoded}")
  end

  def initialize(token)
    @token = token
  end
end
