class PreviewCrawlerJob
  include Sidekiq::Job

  def perform(story_url)
    crawler_story_information(story_url)
  end

  private

  def crawler_story_information(story_url)
    story_rid = story_url.match(%r{/fiction/(\d+)})[1]

    return unless story_rid

    options = {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36 Edg/124.0.0.0'
      }
    }

    response = HTTParty.get(story_url, options)
    docs = Nokogiri::HTML(response.parsed_response)

    tags = docs.css('.fiction-tag').map(&:text)
    genres = Genre.where(name: tags).limit(2)

    author = docs.at_css('.avatar-container-general + .mt-card-content a')
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
        author_avatar: docs.at_css('.avatar-container-general img')['src']
      },
      chapters: []
    }

    chapter_elements = docs.css('#chapters tr td:first a')
    chapter_data_contents = docs.css('#chapters tr td[data-content]')

    chapter_elements.each_with_index do |chapter_element, index|
      chapter_url = chapter_element['href']
      chapter_cid = chapter_url.match(%r{/chapter/(\d+)})[1]

      chapter_hash = {
        title: chapter_element.text.strip,
        cid: chapter_cid,
        position: chapter_data_contents[index]['data-content'].to_i + 1
      }

      story_hash[:chapters] << chapter_hash
    end

    Turbo::StreamsChannel.broadcast_append_to('preview_ongoing_story', partial: 'admin/crawlers/preview_item', locals: { story_hash: story_hash, status: false }, target: 'preview_crawler')
  end
end
