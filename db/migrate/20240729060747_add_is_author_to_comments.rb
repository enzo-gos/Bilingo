class AddIsAuthorToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :is_author, :boolean, default: false
  end
end
