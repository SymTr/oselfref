# README

# 目次
- アプリケーション名
- 概要
- 機能
- 使い方
- テーブル設計
- 開発環境
- 作者

# アプリケーション名
Self Reflection App

# 概要
自分の感情がうごいたできごとを記録するツールです。

# URL
https://oselfref.onrender.com

# テスト用アカウント

## Basic認証 
- ID: admin 
- pass:2222

## Test用アカウント
- email: test@test.com
- pass: 3.14159



# 使い方
アカウントを作成されていない方は、新規登録してください。
アカウントをお持ちの方は、ログインしてください。

感情が揺れた時、フォームを入力して自分の感情を認識できます。
保存したデータはCSV出力できます。

# アプリケーションを作成した背景

友人も自身も、自分のこととなると冷静な判断ができなくなります。
言語化し記録することでまずは内省をおこなう。
さらにAIに分析してもらえば、自分自身の思考の癖がわかり
どのように考えることが自分にとってよいのか教えてもらえます。

# 機能（実装すみ）
- ユーザー登録とログイン
- 投稿の作成、一覧表示、CSV出力

# 機能（実装予定）
- CSV出力範囲設定
- 感情の記録と分析
- AIとの連携（API）

# ER図
![alt text](image.png)

# テーブル設計

## users テーブル

| Column             | Type      | Options                     |
| ------------------ | --------- | --------------------------- |
| nickname           | string    | null: false, unique: true   |
| email.             | string    | null: false, unique: true   |
| encrypted_password | string    | null: false                 |
| created_at         | datetime  | null: false                 |
| updated_at         | datetime  | null: false                 |

### Association

- has_many :posts

## posts テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| event      | text       | null: false                    |
| emotions   | text       | array: true, default: []       |
| self_task  | text       | null: false                    |
| other_task | text       | null: false                    |
| mood_after | text       | null: false                    |
| note       | text       |                                |
| user       | references | null: false, foreign_key: true |
| created_at | datetime   | null: false                    |
| updated_at | datetime   | null: false                    |

### Association

- belongs_to :user

# 画面遷移図
graph TD;
    A[Top-page] --> B[Sign up];
    A[Top-page] --> C[Log in];
    B --> D[New Post];
    B --> F[Posted List];
    C --> D[New Post];
    C --> F[Posted List];

# 開発環境
- Ruby on rails (version 7.0.0)
- Ruby (version 3.2.0)

# ローカルでの動作方法
% git clone https://github.com/SymTr/oselfref.git
% cd oselfref
% bundle install
% yarn install
