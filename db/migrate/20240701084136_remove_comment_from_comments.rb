class RemoveCommentFromComments < ActiveRecord::Migration[7.1]
  def change
    remove_column :comments, :comment, :string
  end
end
