class StoryReport < ApplicationRecord
  belongs_to :story
  belongs_to :reporter, class_name: :User

  has_rich_text :reason

  validates :title,
            :reason,
            presence: true

  enum :status, [:open, :handled, :accepted, :closed], validate: true
end
