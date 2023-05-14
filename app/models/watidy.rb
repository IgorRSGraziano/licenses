require 'http'

class Watidy
  attr :token

  def send_message(number, message)
    HTTP.get("https://api.touswhatsapp.com.br/send/#{@token}/?cmd=chat&to=#{number}@c.us&msg=#{message}")
  end

  def initialize(token)
    @token = token
  end
end
