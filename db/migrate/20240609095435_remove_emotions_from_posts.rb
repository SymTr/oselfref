class RemoveEmotionsFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :emotions, :string
  end
end
