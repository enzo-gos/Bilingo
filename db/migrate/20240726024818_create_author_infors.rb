class CreateAuthorInfors < ActiveRecord::Migration[7.1]
  def change
    create_table :author_infors do |t|
      t.string :nickname
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end

    add_index :author_infors, :nickname, unique: true
  end
end
