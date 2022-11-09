export RAILS_ENV=production
export SECRET_KEY_BASE=$(uuidgen)

rails db:migrate
rails assets:precompile

bundler exec passenger start
