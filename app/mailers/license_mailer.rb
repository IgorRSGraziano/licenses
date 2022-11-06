class LicenseMailer < ApplicationMailer
  def send_license(args)
    @brand = ENV['BRAND_NAME']
    @license = args[:license]
    mail(to: Rails.env.production? ? args[:to] : ENV['SMTP_TEST_TO'],
         subject: "Seu Token de ativação #{@brand}")
  end
end