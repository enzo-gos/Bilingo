class AddStoryViewsCountToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :story_views_count, :integer, default: 0
  end
end
