class AddStoriesCountToAuthorInfors < ActiveRecord::Migration[7.1]
  def change
    add_column :author_infors, :stories_count, :integer, default: 0
  end
end
