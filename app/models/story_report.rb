class StoryReport < ApplicationRecord
  belongs_to :story
  belongs_to :reporter, class_name: :User

  has_many :banned_requests, dependent: :destroy

  has_rich_text :reason

  validates :title,
            :reason,
            presence: true

  enum :status, [:open, :accepted, :closed], validate: true
end
