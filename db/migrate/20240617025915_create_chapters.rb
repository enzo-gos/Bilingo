class CreateChapters < ActiveRecord::Migration[7.1]
  def change
    create_table :chapters do |t|
      t.string :title, default: ''
      t.boolean :published, default: false
      t.integer :position
      t.bigint :views, default: 0
      t.references :story, null: false

      t.timestamps
    end
  end
end
