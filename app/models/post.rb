class Post < ApplicationRecord
  belongs_to :user
  
  validates :situation, :thoughts, :emotions, :self_task, :others_task, 
            :supporting_evidence, :contrary_evidence, :alternative_thinking, :mood_after, presence: true

  serialize :emotions, Array
end

# serializeメソッド
# Rubyのオブジェクトをデータベースに保存する方法の一つ。配列やハッシュなどの複雑なオブジェクトを特定のテーブルのカラムに保存できる。
# emotionsという名前のフィールド（または属性）をRubyのArrayとして扱うようRailsに指示している。
# emotionsフィールドにデータを保存する際、Railsはそのデータを自動的にシリアル化（テキスト表現に変換）し、データベースに保存。
# そのデータを取り出す時には、再びRubyのArrayオブジェクトにデシリアル化（テキスト表現からオブジェクトに変換）する。
