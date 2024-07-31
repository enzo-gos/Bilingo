class OngoingCrawlerJob
  include Sidekiq::Job
  include Sidekiq::Status::Worker
  require 'open-uri'

  PERMIT_IMAGE_FORMAT = %w[png jpg jpeg].freeze

  def perform(story_url)
    options = {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36 Edg/124.0.0.0'
      }
    }

    full_story = crawler_story_information(story_url, options)

    author = create_author(full_story)
    story = create_story(full_story, author)
    create_chapters(full_story, story)

    full_story[:status] = 'success'

    store story_hash: full_story.to_json

    Turbo::StreamsChannel.broadcast_update_to('process_ongoing_story', partial: 'admin/crawlers/chapter_info_item', locals: { story_hash: full_story, status: 'success' }, target: "crawler_chapter_items#{full_story[:story][:rid]}")
  end

  private

  def story_crawler(docs, story_rid)
    tags = docs.css('.fiction-tag').map(&:text)
    genres = Genre.where(name: tags).limit(2)

    genres = [Genre.create(name: tags[2]), nil] unless genres.first.present?

    author = docs.at_css('.avatar-container-general + .mt-card-content a')
    author_image = docs.at_css('.avatar-container-general img')['src']
    author_image = "https://www.royalroad.com#{author_image}" if author_image.include?('dist/img')

    story_image = docs.at_css('.cover-art-container img')['src']
    story_image = "https://www.royalroad.com#{story_image}" if story_image.include?('nocover')

    story_hash = {
      story: {
        name: docs.at_css('.fic-title h1').text,
        tag_list: tags.join(','),
        primary_genre: genres.first,
        secondary_genre: genres.last,
        description: docs.css('.fiction-info .description .hidden-content').inner_html.strip,
        rid: story_rid
      },
      author: {
        nickname: author.text,
        aid: author['href'].match(%r{/profile/(\d+)})[1]
      },
      meta: {
        image_url: story_image,
        author_avatar: author_image
      },
      chapters: [],
      status: 'processing',
      chapter_status: {}
    }

    store story_hash: story_hash.to_json

    Turbo::StreamsChannel.broadcast_append_to('process_ongoing_story', partial: 'admin/crawlers/preview_item', locals: { story_hash: story_hash, status: 'processing' }, target: 'ongoing_crawler')
    story_hash
  end

  def number_chapters_fetch(chapter_elements, story_hash, exists_story, guids)
    chapter_elements.each do |chapter_element|
      chapter_url = chapter_element['href']
      chapter_cid = chapter_url.match(%r{/chapter/(\d+)})[1]

      next if exists_story&.chapters&.find_by_cid(chapter_cid).present? && guids.include?(chapter_cid) == false

      story_hash[:chapter_status].merge!(
        {
          chapter_cid => {
            title: chapter_element.text.strip,
            crawl_status: 'crawling'
          }
        }
      )

      store story_hash: story_hash.to_json

      Turbo::StreamsChannel.broadcast_append_to('process_ongoing_story', partial: 'admin/crawlers/chapter_item', locals: { chapter: { cid: chapter_cid, title: chapter_element.text.strip, crawl_status: 'crawling' } }, target: "crawl_chapters_#{story_hash[:story][:rid]}")
    end

    story_hash
  end

  def crawler_story_information(story_url, options)
    story_rid = story_url.match(%r{/fiction/(\d+)})[1]

    return unless story_rid

    response = HTTParty.get(story_url, options)
    docs = Nokogiri::HTML(response.parsed_response)

    story_hash = story_crawler(docs, story_rid)

    guids, exists_story = get_updated_history(story_rid, options)

    chapter_elements = docs.css('#chapters tr td:first a')
    chapter_data_contents = docs.css('#chapters tr td[data-content]')

    story_hash.merge!(number_chapters_fetch(chapter_elements, story_hash, exists_story, guids))

    chapter_elements.each_with_index do |chapter_element, index|
      chapter_url = chapter_element['href']
      chapter_cid = chapter_url.match(%r{/chapter/(\d+)})[1]

      next if exists_story&.chapters&.find_by_cid(chapter_cid).present? && guids.include?(chapter_cid) == false

      chapter_hash = {
        title: chapter_element.text.strip,
        content: crawler_story_chapter("https://www.royalroad.com#{chapter_url}", options),
        cid: chapter_cid,
        position: chapter_data_contents[index]['data-content'].to_i + 1
      }

      story_hash[:chapters] << chapter_hash

      story_hash[:chapter_status].merge!(
        {
          chapter_cid => {
            title: chapter_element.text.strip,
            crawl_status: 'waiting'
          }
        }
      )

      store story_hash: story_hash.to_json
      Turbo::StreamsChannel.broadcast_replace_to('process_ongoing_story', partial: 'admin/crawlers/chapter_item', locals: { chapter: { cid: chapter_cid, title: chapter_element.text.strip, crawl_status: 'waiting' } }, target: "crawler_chapter_status#{chapter_cid}")
    end

    story_hash
  end

  def create_author(full_story)
    author = AuthorInfor.find_by_aid(full_story[:author][:aid])
    if author.present?
      author.update!(full_story[:author]) do |a|
        image, image_name = fetch_image(full_story[:meta][:author_avatar])
        a.avatar.attach(io: image, filename: image_name)
      end
      author
    else
      AuthorInfor.create!(full_story[:author]) do |a|
        image, image_name = fetch_image(full_story[:meta][:author_avatar])
        a.avatar.attach(io: image, filename: image_name)
        a.crawler = true
      end
    end
  end

  def create_story(full_story, author)
    story = Story.find_by_rid(full_story[:story][:rid])
    if story.present?
      story.update!(full_story[:story]) do |s|
        image, image_name = fetch_image(full_story[:meta][:image_url])
        s.cover_image.attach(io: image, filename: image_name)
      end
      story
    else
      Story.create!(full_story[:story]) do |s|
        s.author = author
        image, image_name = fetch_image(full_story[:meta][:image_url])
        s.cover_image.attach(io: image, filename: image_name)
        s.crawler = true
      end
    end
  end

  def update_exists_chapter(full_story, chapter, exists_chapter)
    full_story[:chapter_status].merge!(
      {
        chapter[:cid] => {
          title: chapter[:title],
          crawl_status: 'updating'
        }
      }
    )

    store story_hash: full_story.to_json
    Turbo::StreamsChannel.broadcast_replace_to('process_ongoing_story', partial: 'admin/crawlers/chapter_item', locals: { chapter: { cid: chapter[:cid], title: chapter[:title], crawl_status: 'updating' } }, target: "crawler_chapter_status#{chapter[:cid]}")
    exists_chapter.update!(chapter)

    full_story[:chapter_status].merge!(
      {
        chapter[:cid] => {
          title: chapter[:title],
          crawl_status: 'updated'
        }
      }
    )

    store story_hash: full_story.to_json
    Turbo::StreamsChannel.broadcast_replace_to('process_ongoing_story', partial: 'admin/crawlers/chapter_item', locals: { chapter: { cid: chapter[:cid], title: chapter[:title], crawl_status: 'updated' } }, target: "crawler_chapter_status#{chapter[:cid]}")
  end

  def create_chapters(full_story, story)
    full_story[:chapters].each do |chapter|
      exists_chapter = Chapter.find_by_cid(chapter[:cid])
      if exists_chapter.present?
        update_exists_chapter(full_story, chapter, exists_chapter)
      else
        full_story[:chapter_status].merge!(
          {
            chapter[:cid] => {
              title: chapter[:title],
              crawl_status: 'creating'
            }
          }
        )

        store story_hash: full_story.to_json
        Turbo::StreamsChannel.broadcast_replace_to('process_ongoing_story', partial: 'admin/crawlers/chapter_item', locals: { chapter: { cid: chapter[:cid], title: chapter[:title], crawl_status: 'creating' } }, target: "crawler_chapter_status#{chapter[:cid]}")
        Chapter.create!(chapter) do |c|
          c.story = story
          c.published = true
          c.crawler = true
        end
        full_story[:chapter_status].merge!(
          {
            chapter[:cid] => {
              title: chapter[:title],
              crawl_status: 'created'
            }
          }
        )

        store story_hash: full_story.to_json
        Turbo::StreamsChannel.broadcast_replace_to('process_ongoing_story', partial: 'admin/crawlers/chapter_item', locals: { chapter: { cid: chapter[:cid], title: chapter[:title], crawl_status: 'created' } }, target: "crawler_chapter_status#{chapter[:cid]}")
      end
    end
  end

  def crawler_story_chapter(url, options)
    response = HTTParty.get(url, options)
    docs = Nokogiri::HTML(response.parsed_response)

    docs.css('.chapter-content').inner_html.strip
  end

  def get_updated_history(story_rid, options)
    exists_story = Story.find_by_rid(story_rid)

    if exists_story.present?
      xml_updated_data = HTTParty.get("https://www.royalroad.com/fiction/syndication/#{story_rid}", options)
      if xml_updated_data.success?
        doc = Nokogiri::XML(xml_updated_data.body)
        guids = doc.xpath('//item/guid').map(&:text)
        pub_dates = doc.xpath('//item/pubDate').map { |date| Time.parse(date.text).to_datetime }

        guids = guids.select.with_index { |g, index| exists_story.chapters.find_by_cid(g) && pub_dates[index] > exists_story.chapters.find_by_cid(g).updated_at }
      end
    end

    [guids, exists_story]
  end

  def fetch_image(image_url)
    uri = URI.parse(image_url)
    image = uri.open
    image_name = File.basename(image_url)

    [image, image_name]
  end

  def get_content_type(image_url)
    ext_name = File.extname(image_url).delete('.')
    return unless PERMIT_IMAGE_FORMAT.include?(ext_name)

    "image/#{ext_name}"
  end

  def str2num(str)
    /(^\d{1,3}(,\d{3})*).*$/.match(str).captures.first.gsub(',', '')
  end
end
