class AddViewUpdatedAtToStoryViews < ActiveRecord::Migration[7.1]
  def change
    add_column :story_views, :view_updated_at, :datetime
  end
end
