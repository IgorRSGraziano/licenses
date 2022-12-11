# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'securerandom'

status = [0, 1, 2]

client = Client.create_or_find_by(brand: 'Client', token: '1')
User.create(username: 'adm', email: 'adm@adm.com', password: '123456', client_id: client.id)

{ 'HOTTOK' => 'Token HOTTOK da Hotmart', 'EMAIL_TUTORIAL_VIDEO' => 'Link do vídeo de tutorial (Usado no envio de e-mail)', 'EMAIL_INSTALL_VIDEO' => 'Link do vídeo de instalação (Usado no envio de e-mail)' }.each do |identifier, name|
  Parameter.create_or_find_by(identifier: identifier, name: name)
end

(1..20).each do |_|
  License.create(
    key: SecureRandom.uuid,
    status: status.sample,
    client_id: client.id
  )
end
