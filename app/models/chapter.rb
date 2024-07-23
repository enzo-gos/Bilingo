class Chapter < ApplicationRecord
  require 'digest'

  belongs_to :story
  has_many :comments, dependent: :destroy
  has_many :story_views, dependent: :destroy
  has_many :notification_mentions, as: :record, dependent: :destroy, class_name: 'Noticed::Event'

  has_one_attached :heading_image, dependent: :destroy
  has_rich_text :content

  acts_as_list scope: [:story_id]

  before_save :generate_content_id
  after_update_commit :notice_published_chapter

  def has_comment?(p_id)
    comments.where(paragraph_id: p_id).any?
  end

  def count_comments(p_id)
    comments.where(paragraph_id: p_id).size
  end

  def next_chapter
    Chapter.where('story_id = ? AND position < ? AND published = ?', story_id, position, true).order(position: :desc).first
  end

  def prev_chapter
    Chapter.where('story_id = ? AND position > ? AND published = ?', story_id, position, true).order(position: :asc).first
  end

  private

  def generate_content_id
    html_content = content.body.to_s
    fragment = Nokogiri::HTML.fragment(html_content)

    fragment.children.each_with_index do |child, index|
      child['data-p-id'] = ''
      child['data-p-id'] = Digest::SHA256.hexdigest("#{index}_#{child}")
    end

    content.body = fragment.to_html
  end

  def notice_published_chapter
    Writer::PublishChapterNotifier.with(record: self, icon: :info).deliver(story.get_upvotes(vote_scope: 'bookmark').map(&:voter)) if published
  end
end
