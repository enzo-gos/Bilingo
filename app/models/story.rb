class Story < ApplicationRecord
  belongs_to :primary_genre, class_name: :Genre
  belongs_to :secondary_genre, class_name: :Genre, optional: true
  belongs_to :author, class_name: :AuthorInfor, counter_cache: true

  has_many :chapters, -> { order(position: :asc) }, dependent: :destroy
  has_many :story_views, dependent: :destroy
  has_many :banned_requests, dependent: :destroy
  has_many :story_reports, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy
  has_rich_text :description

  acts_as_taggable_on :tags
  acts_as_list scope: [:author_id], add_new_at: :top
  acts_as_votable

  # validates :name,
  #           :author,
  #           :primary_genre_id,
  #           :description,
  #           :cover_image,
  #           :tag_list,
  #           :language_code,
  #           presence: true

  validates :name,
            :primary_genre_id,
            :cover_image,
            :tag_list,
            presence: true

  scope :with_published, -> { joins(:chapters).where(chapters: { published: true }, banned: false).distinct }

  scope :top_viewed, ->(limit = 3) {
    subquery = StoryView.select('story_id, COUNT(*) AS view_count').group(:story_id)

    left_outer_joins(:story_views)
      .select('stories.*, COALESCE(subquery.view_count, 0) AS view_count')
      .joins("LEFT OUTER JOIN (#{subquery.to_sql}) AS subquery ON subquery.story_id = stories.id")
      .group('stories.id, subquery.view_count')
      .order(Arel.sql('COALESCE(subquery.view_count, 0) DESC, stories.id'))
      .limit(limit)
  }

  scope :recently_read, ->(ip_address, limit = 5) {
    joins(:story_views)
      .where(story_views: { ip_address: ip_address })
      .select('stories.*, MAX(story_views.viewed_on) AS last_viewed_on')
      .group('stories.id')
      .order('last_viewed_on DESC')
      .limit(limit)
  }

  def most_recent_chapter_for(ip_address)
    StoryView
      .where(story_id: id, ip_address: ip_address)
      .order(updated_at: :desc)
      .limit(1)
      .pluck(:chapter_id)
      .first
  end

  def number_of_published
    chapters.where(published: true).count
  end

  def number_of_draft
    chapters.where(published: false).count
  end

  def views
    story_views.size
  end

  def comments
    chapters.joins(:comments).count
  end

  def genres
    genres = [primary_genre.name]
    genres |= [secondary_genre.name] if secondary_genre
    genres
  end

  def track_view(ip_address, chapter_id)
    view = story_views.create_or_find_by(ip_address: ip_address, chapter_id: chapter_id, viewed_on: Date.current)
    view.update(view_updated_at: DateTime.current)
  end

  def views_by_day(year = Date.current.year, month = Date.current.month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    story_views
      .where(viewed_on: start_date..end_date)
      .group(:viewed_on)
      .count
      .transform_keys(&:day)
  end

  def bookmark?(user)
    user&.voted_up_on?(self, vote_scope: :bookmark)
  end

  def toggle_bookmark!(user)
    if bookmark?(user)
      downvote_from user, vote_scope: :bookmark
    else
      vote_by voter: user, vote_scope: :bookmark
    end
  end
end
