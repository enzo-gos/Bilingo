class Chapter < ApplicationRecord
  require 'digest'

  belongs_to :story
  has_one_attached :heading_image, dependent: :destroy
  has_rich_text :content
  acts_as_list scope: [:story_id]

  before_update :generate_content_id

  private

  def generate_content_id
    html_content = content.body.to_s
    fragment = Nokogiri::HTML.fragment(html_content)

    fragment.children.each do |child|
      next if child['id'].present?

      child['data-p-id'] = Digest::SHA256.hexdigest(child.to_s)
    end

    content.body = fragment.to_html
  end
end
