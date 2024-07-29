class AddCidToChapters < ActiveRecord::Migration[7.1]
  def change
    add_column :chapters, :cid, :bigint, default: 0
    add_column :chapters, :crawler, :boolean, default: false
    add_index :chapters, [:id, :cid], unique: true
  end
end
