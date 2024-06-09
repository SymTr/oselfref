class AddEmotionsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :emotions, :text
  end
end
