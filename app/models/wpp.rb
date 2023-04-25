require 'http'

class Wpp

  def self.send_message(phone, message)
    HTTP.get "#{@url}/?cmd=chat&id=#{@token}&to=#{phone}@c.us&msg=#{message}"
  rescue StandardError => e
    # Ignored
  end

  @url = 'https://api.touswhatsapp.com.br/send'
  @token = ENV['WPP_TOKEN']
end
