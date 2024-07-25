class ChangePostsTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :posts, :event, :situation
    add_column :posts, :thoughts, :text
    rename_column :posts, :other_task, :others_task
    add_column :posts, :supporting_evidence, :text
    add_column :posts, :contrary_evidence, :text
    rename_column :posts, :note, :alternative_thinking
  end
end
