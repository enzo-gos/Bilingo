class Comment < ApplicationRecord
  belongs_to :commenter, class_name: :User
  belongs_to :chapter

  validates :comment,
            :commenter,
            :chapter,
            :paragraph_id,
            presence: true
end
