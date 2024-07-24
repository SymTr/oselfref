FROM ruby:3.1.2

# システムの依存関係をインストール
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client libpq-dev

WORKDIR /myapp

# GemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Gemのインストール
RUN bundle install

# アプリケーションコードをコピー
COPY . /myapp

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]