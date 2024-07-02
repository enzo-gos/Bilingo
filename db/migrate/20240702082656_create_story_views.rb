class CreateStoryViews < ActiveRecord::Migration[7.1]
  def change
    create_table :story_views do |t|
      t.string :ip_address
      t.references :story, null: false, foreign_key: true
      t.references :chapter, null: false, foreign_key: true
      t.date :viewed_on

      t.timestamps
    end
    add_index :story_views, [:story_id, :ip_address, :chapter_id, :viewed_on], unique: true
  end
end
