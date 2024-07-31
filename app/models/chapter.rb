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

  validates :title, length: { maximum: 150 }

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

    doc = Nokogiri::HTML(html_content)

    doc.xpath('//*[@*[starts-with(name(), "data-")]]').each do |node|
      node.attributes.each do |name, _|
        node.remove_attribute(name) if name.start_with?('data-')
      end
    end

    clean_attrs = ['style', 'dir', 'id', 'onclick', 'onerror', 'onload', 'onmouseover', 'onsubmit', 'action', 'class']
    doc.xpath('//*[@*]').each do |node|
      clean_attrs.each { |attr| node.remove_attribute(attr) if node[attr] }
    end

    clean_tags = ['meta', 'link', 'script', 'style', 'iframe', 'frame', 'embed', 'object', 'applet', 'form', 'input', 'button', 'a', 'select', 'option', 'img']
    clean_tags.each { |tag| doc.css(tag).remove }

    doc.css('div').each do |div|
      div.swap(div.children)
    end

    sanitized_html = doc.to_html

    safe_html = Loofah.fragment(sanitized_html).scrub!(:prune).to_html
    fragment = Nokogiri::HTML.fragment(safe_html)

    fragment.children.each_with_index do |child, index|
      child['data-p-id'] = ''
      child['data-p-id'] = Digest::SHA256.hexdigest("#{index}_#{child}")
    end

    content.body = fragment.to_html
  end

  def notice_published_chapter
    Writer::PublishChapterNotifier.with(record: self, icon: :info).deliver(story.get_upvotes(vote_scope: 'bookmark').map(&:voter)) if published && story
  end
end
