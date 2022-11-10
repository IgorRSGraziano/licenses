source /usr/local/rvm/bin/rvm

cd /var/www/licenses
export RAILS_ENV=production
export SECRET_KEY_BASE=$(uuidgen)

rails db:migrate && rails assets:precompile
bundler exec passenger start
#  && bin/dev s
