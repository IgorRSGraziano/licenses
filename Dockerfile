FROM ruby:3.1.2

ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=$(uuidgen)

RUN apt update
RUN apt install nodejs npm default-mysql-client -y

WORKDIR /app

RUN gem install bundler
COPY Gemfile Gemfile.lock ./
RUN bundler

COPY package.json ./
RUN npm i --force

COPY . ./

RUN #./bin/rails db:migrate
RUN ./bin/rails assets:precompile

EXPOSE 3000

CMD bundler exec passenger start
