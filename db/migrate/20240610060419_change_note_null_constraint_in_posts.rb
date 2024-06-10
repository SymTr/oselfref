class ChangeNoteNullConstraintInPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :note, true
  end
end
