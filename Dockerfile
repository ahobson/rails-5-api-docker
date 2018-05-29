FROM ruby:2.4.2-slim-stretch

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Add build layer for ruby dependencies
COPY Gemfile $APP_HOME/
COPY Gemfile.lock $APP_HOME/
ENV BINSTUBS_DIR=/packages/binstubs

RUN set -x \
  && apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
  && bundle install \
    --binstubs ${BINSTUBS_DIR} \
  && DEBIAN_FRONTEND=noninteractive apt-get purge -y \
    build-essential \
  && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
  && DEBIAN_FRONTEND=noninteractive apt-get clean -y

ENV PATH=${BINSTUBS_DIR}:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN bundle binstubs \
    bundler \
    --path ${BINSTUBS_DIR}

COPY Rakefile config.ru $APP_HOME/
COPY app $APP_HOME/app
COPY bin $APP_HOME/bin
COPY config $APP_HOME/config
COPY db $APP_HOME/db
COPY lib $APP_HOME/lib
COPY spec $APP_HOME/test

# Launch the rails server
CMD ["bundle", "exec", "rails", "server"]

