# spec/models/chapter_spec.rb
require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'associations' do
    it { should belong_to(:story) }
    it { should have_many(:comments) }
    it { should have_many(:story_views) }
    it { should have_one_attached(:heading_image) }
  end

  describe 'rich text' do
    it 'has rich text for content' do
      expect(Chapter.new).to respond_to(:content)
    end
  end

  describe 'acts_as_list' do
    it 'should act as list scoped to story_id' do
      story = create(:story)
      chapter1 = create(:chapter, story: story)
      chapter2 = create(:chapter, story: story)
      expect(chapter1.position).to eq(1)
      expect(chapter2.position).to eq(2)
    end
  end

  describe '#has_comment?' do
    let(:chapter) { create(:chapter) }
    let(:paragraph_id) { SecureRandom.uuid }
    let!(:comment) { create(:comment, chapter: chapter, paragraph_id: paragraph_id) }

    it 'returns true if the paragraph has comments' do
      expect(chapter.has_comment?(paragraph_id)).to be true
    end

    it 'returns false if the paragraph does not have comments' do
      expect(chapter.has_comment?(SecureRandom.uuid)).to be false
    end
  end

  describe '#next_chapter' do
    let!(:story) { create(:story) }
    let!(:chapter) { create(:chapter, story: story, position: 3, published: true) }
    let!(:next_chapter_unplished) { create(:chapter, story: story, position: 2, published: false) }

    it 'returns chapter if next published chapter available' do
      next_chapter = create(:chapter, story: story, position: 1, published: true)

      expected_chapter = chapter.next_chapter
      expect(expected_chapter).to eq(next_chapter)
    end

    it 'returns nil if next published chapter unavailable' do
      create(:chapter, story: story, position: 1, published: false)

      expected_chapter = chapter.next_chapter
      expect(expected_chapter).to eq(nil)
    end
  end

  describe '#prev_chapter' do
    let!(:story) { create(:story) }
    let!(:chapter) { create(:chapter, story: story, position: 3, published: true) }
    let!(:prev_chapter_unpublished) { create(:chapter, story: story, position: 5, published: false) }
    it 'returns chapter if prev published chapter available' do
      prev_chapter = create(:chapter, story: story, position: 4, published: true)

      expected_chapter = chapter.prev_chapter
      expect(expected_chapter).to eq(prev_chapter)
    end

    it 'returns nil if prev published chapter unavailable' do
      create(:chapter, story: story, position: 4, published: false)

      expected_chapter = chapter.prev_chapter
      expect(expected_chapter).to eq(nil)
    end
  end

  describe '#count_comments' do
    let(:chapter) { create(:chapter) }
    let(:paragraph_id) { SecureRandom.uuid }
    let!(:comment1) { create(:comment, chapter: chapter, paragraph_id: paragraph_id) }
    let!(:comment2) { create(:comment, chapter: chapter, paragraph_id: paragraph_id) }

    it 'returns the number of comments for the paragraph' do
      expect(chapter.count_comments(paragraph_id)).to eq(2)
    end
  end

  describe 'callbacks' do
    describe 'before_save :generate_content_id' do
      let(:chapter) { create(:chapter, content: '<p>Paragraph 1</p><p>Paragraph 2</p>') }

      it 'generates a unique content ID for each paragraph' do
        chapter.save
        html_content = chapter.content.body.to_s

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
          old_id = child['data-p-id']
          expect(old_id).to be_present if old_id
          child['data-p-id'] = ''
          expected_digest = Digest::SHA256.hexdigest("#{index}_#{child}").to_s.force_encoding('UTF-8')
          expect(old_id).to eq(expected_digest) if old_id
        end
      end
    end
  end
end
