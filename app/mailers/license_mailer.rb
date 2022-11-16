class LicenseMailer < ApplicationMailer
  def send_license(args)
    @brand = ENV['BRAND_NAME']
    @license = args[:license]
    mail(to: Rails.env.production? ? args[:to] : ENV['SMTP_TEST_TO'],
         subject: "CHAVE #{@brand}")
  end

  def cancel_license(args)
    @brand = ENV['BRAND_NAME']
    @license = args[:license]
    mail(to: Rails.env.production? ? args[:to] : ENV['SMTP_TEST_TO'],
         subject: "Expiração de licença #{@brand}")
  end
end