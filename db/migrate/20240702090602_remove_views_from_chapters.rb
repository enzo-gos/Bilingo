class RemoveViewsFromChapters < ActiveRecord::Migration[7.1]
  def change
    remove_column :chapters, :views, :bigint
  end
end
