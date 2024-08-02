# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    # eventの定義を削除または正しい属性名に修正
    situation { "テスト状況" }
    self_task { "自分のタスク" }
    others_task { "他人のタスク" }
    mood_after { "後の気分" }
    alternative_thinking { "代替思考" }
    emotions { ["喜び", "悲しみ"] }
    thoughts { "思考" }
    supporting_evidence { "支持する証拠" }
    contrary_evidence { "反対の証拠" }
    association :user
  end
end