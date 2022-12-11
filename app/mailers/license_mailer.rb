class LicenseMailer < ApplicationMailer
  def send_license(args)
    @license = args[:license]
    client = args[:client]

    @brand = client.brand
    @install_video = client.param('EMAIL_INSTALL_VIDEO').value(client.id)
    @tutorial_video = client.param('EMAIL_TUTORIAL_VIDEO').value(client.id)
    mail(to: Rails.env.production? ? args[:to] : ENV['SMTP_TEST_TO'],
         subject: "CHAVE #{@brand}")
  end

  def cancel_license(args)
    @brand = args[:brand]
    @license = args[:license]
    mail(to: Rails.env.production? ? args[:to] : ENV['SMTP_TEST_TO'],
         subject: "Expiração de licença #{@brand}")
  end
end