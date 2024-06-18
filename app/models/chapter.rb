class Chapter < ApplicationRecord
  belongs_to :story
  has_one_attached :heading_image, dependent: :destroy
  has_rich_text :content
  acts_as_list scope: [:story_id]
end
