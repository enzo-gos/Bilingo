class AuthorInfor < ApplicationRecord
  belongs_to :user, optional: true

  has_many :stories, -> { includes([cover_image_attachment: :blob]).order(position: :asc) }, foreign_key: :author

  has_one_attached :avatar, dependent: :destroy

  validates :nickname, presence: true, uniqueness: true

  def total_followers
    stories
      .joins(:votes_for)
      .sum('CASE votes.vote_flag WHEN true THEN 1 WHEN false THEN -1 ELSE 0 END')
  end
end
