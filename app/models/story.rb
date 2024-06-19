class Story < ApplicationRecord
  belongs_to :primary_genre, class_name: :Genre
  belongs_to :secondary_genre, class_name: :Genre, optional: true
  belongs_to :author, class_name: :User

  has_many :chapters, -> { order(position: :asc) }, dependent: :destroy, counter_cache: true
  has_one_attached :cover_image, dependent: :destroy

  acts_as_taggable_on :tags
  acts_as_list scope: [:author_id], add_new_at: :top

  validates :name,
            :author,
            :primary_genre_id,
            :description,
            :cover_image,
            :tag_list,
            :language_code,
            presence: true

  scope :with_published, -> { where(chapters: { published: true }).distinct }

  def number_of_published
    chapters.where(published: true).count
  end

  def number_of_draft
    chapters.where(published: false).count
  end

  def views
    chapters.sum(:views)
  end

  def genres
    genres = [primary_genre.name]
    genres |= [secondary_genre.name] if secondary_genre
    genres
  end
end
