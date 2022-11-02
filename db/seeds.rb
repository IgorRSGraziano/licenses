# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'securerandom'

status = %w[active inactive suspended]

(1..20).each { |_|
  License.create(
    key: SecureRandom.uuid,
    status: status.sample
  )
}