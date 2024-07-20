FROM ruby:3.1.2

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# アプリケーションディレクトリの作成
RUN mkdir /oselfref
WORKDIR /oselfref

# GemfileとGemfile.lockをコピーし、gemをインストール
COPY Gemfile /oselfref/Gemfile
COPY Gemfile.lock /oselfref/Gemfile.lock
RUN bundle install

# アプリケーションコードをコピー
COPY . /oselfref

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]