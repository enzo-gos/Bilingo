class ChangeAuthorReferenceInStory < ActiveRecord::Migration[7.1]
  def change
    remove_reference :stories, :author, foreign_key: { to_table: :users }
    add_reference :stories, :author, foreign_key: { to_table: :author_infors }
  end
end
