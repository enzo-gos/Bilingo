class AddAidToAuthorInfors < ActiveRecord::Migration[7.1]
  def change
    add_column :author_infors, :aid, :bigint, default: 0
    add_column :author_infors, :crawler, :boolean, default: false
    add_index :author_infors, [:id, :aid], unique: true
  end
end
