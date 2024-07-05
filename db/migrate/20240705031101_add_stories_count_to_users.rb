class AddStoriesCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stories_count, :integer, default: 0
  end
end
