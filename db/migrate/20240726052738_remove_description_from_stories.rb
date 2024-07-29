class RemoveDescriptionFromStories < ActiveRecord::Migration[7.1]
  def change
    remove_column :stories, :description, :string
  end
end
