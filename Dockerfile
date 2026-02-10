# # syntax = docker/dockerfile:1
#
## Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
#ARG RUBY_VERSION=3.3.4
#FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base
#
## Rails app lives here
#WORKDIR /rails
#
## Set production environment
#ENV RAILS_ENV="production" \
#    BUNDLE_DEPLOYMENT="1" \
#    BUNDLE_PATH="/usr/local/bundle" \
#    BUNDLE_WITHOUT="development"
#
## Throw-away build stage to reduce size of final image
#FROM base as build
#
## Install packages needed to build gems and node modules
#RUN apt-get update -qq && \
#    apt-get install --no-install-recommends -y build-essential curl git libpq-dev libvips node-gyp pkg-config python-is-python3
#
## Install JavaScript dependencies
#ARG NODE_VERSION=20.16.0
#ARG YARN_VERSION=1.22.22
#ENV PATH=/usr/local/node/bin:$PATH
#RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
#    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
#    npm install -g yarn@$YARN_VERSION && \
#    rm -rf /tmp/node-build-master
#
## Install application gems
#COPY Gemfile Gemfile.lock ./
#RUN bundle install && \
#    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
#    bundle exec bootsnap precompile --gemfile
#
## Install node modules
#COPY package.json yarn.lock ./
#RUN yarn install --frozen-lockfile


# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /app

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

FROM base as build

# Устанавливаем зависимости для Ruby и Node
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libpq-dev libvips node-gyp pkg-config python-is-python3

# Node и Yarn
ARG NODE_VERSION=20.16.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Копируем Gemfile и устанавливаем гемы
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Копируем node модули
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Копируем весь проект
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ---------------------------
# Финальный образ с nginx
# ---------------------------
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

WORKDIR /app

# Устанавливаем runtime зависимости и nginx
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl postgresql-client libsqlite3-0 libvips nginx && \
    rm -rf /var/lib/apt/lists/*

# Копируем артефакты
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Создаём конфиг nginx для глобального редиректа
RUN echo 'server {\n\
    listen 3000;\n\
    server_name _;\n\
    location / {\n\
        return 301 https://murti.world/giftprabhupada;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

# Запуск nginx на переднем плане
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl postgresql-client libsqlite3-0 libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
