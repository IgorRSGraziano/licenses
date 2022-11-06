class LicenseMailer < ApplicationMailer
  #TODO criar template de envio de email
  def send_license(args)
    mail(to: Rails.env.production? ? args[:to] : ENV['SMTP_TEST_TO'],
         subject: "Seu Token de ativação #{ENV['BRAND_NAME']}",
         body: 'OI')
  end
end