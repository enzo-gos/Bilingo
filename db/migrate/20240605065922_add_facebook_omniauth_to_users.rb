class AddFacebookOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :avatar, :text
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    add_index :users, [:provider, :uid], unique: true
  end
end
