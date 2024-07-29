class AddRidToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :rid, :bigint, default: 0
    add_column :stories, :crawler, :boolean, default: false
    add_index :stories, [:id, :rid], unique: true
  end
end
