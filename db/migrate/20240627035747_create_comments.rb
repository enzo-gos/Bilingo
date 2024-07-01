class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :commenter, null: false, foreign_key: { to_table: :users }
      t.references :chapter, null: false, foreign_key: true
      t.string :comment
      t.string :paragraph_id

      t.timestamps
    end
  end
end
