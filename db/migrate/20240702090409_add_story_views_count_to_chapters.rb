class AddStoryViewsCountToChapters < ActiveRecord::Migration[7.1]
  def change
    add_column :chapters, :story_views_count, :integer, default: 0
  end
end
