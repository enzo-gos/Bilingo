class CreateStoryReports < ActiveRecord::Migration[7.1]
  def change
    create_table :story_reports do |t|
      t.string :title
      t.integer :status, default: 0
      t.references :story, null: false, foreign_key: true
      t.references :reporter, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
