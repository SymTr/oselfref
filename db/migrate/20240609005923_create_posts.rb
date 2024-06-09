class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.text :event, null: false
      t.text :emotions, null: false
      t.text :self_task, null: false
      t.text :other_task, null: false
      t.text :mood_after, null: false
      t.text :note
      # t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
