class AddBannedToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :banned, :boolean, default: false
  end
end
