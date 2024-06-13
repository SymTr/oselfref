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


# 機能
ユーザー登録とログイン
投稿の作成、表示
感情の記録と分析


# 使い方
アカウントを作成されていない方は、新規登録してください。
アカウントをお持ちの方は、ログインしてください。

感情が揺れた時、フォームを入力して自分の感情を認識できます。
保存したデータはCSV出力できます。

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
