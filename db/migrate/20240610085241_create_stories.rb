class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.string :name
      t.text :description
      t.string :language_code
      t.integer :position
      t.references :primary_genre, null: false, foreign_key: { to_table: :genres }
      t.references :secondary_genre, null: true, foreign_key: { to_table: :genres }
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
