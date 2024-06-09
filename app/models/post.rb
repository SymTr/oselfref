class Post < ApplicationRecord
  validates :event, :emotions, :self_task, :other_task, :mood_after, :note, presence: true
end
