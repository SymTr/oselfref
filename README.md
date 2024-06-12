# README

# 使い方
感情が揺れた時、フォームを入力して自分の感情を認識できます。
そして自分に変えられること、変えられないことを確認しましょう。

# テーブル設計

## users テーブル

| Column             | Type      | Options                     |
| ------------------ | --------- | --------------------------- |
| nickname           | string    | null: false, unique: true   |
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
