# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    event { "Some event" }
    emotions { ["喜び", "悲しみ"] }
    self_task { "Self task" }
    other_task { "Other task" }
    mood_after { "Mood after" }
    note { "Note" }
    association :user
  end
end
