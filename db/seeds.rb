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
User.create(username: 'adm', email: 'adm', password: '123456', client_id: client.id)

(1..20).each do |_|
  License.create(
    key: SecureRandom.uuid,
    status: status.sample,
    client_id: client.id
  )
end
