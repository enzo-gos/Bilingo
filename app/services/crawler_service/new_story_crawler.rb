# app/services/wattpad_api_service.rb
class CrawlerService::NewStoryCrawler < ApplicationService
  require 'open-uri'

  PERMIT_IMAGE_FORMAT = %w[png jpg jpeg].freeze

  def initialize(base_url, rank)
    @base_url = base_url
    @rank = rank.to_i
    @page = (@rank / 20.0).ceil
    @options = {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36 Edg/124.0.0.0'
      }
    }
  end

  def call
    @page.times do |index|
      url = "#{@base_url}?page=#{index + 1}"
      response = HTTParty.get(url, @options)
      parse_response(response)
    end
  end

  private

  def parse_response(response)
    if response.success?
      doc = Nokogiri::HTML(response.parsed_response)

      story_elements = doc.css('.fiction-list-item.row')

      stories = []

      story_elements.each do |story_element|
        story_url = crawler_story_url(story_element)
        OngoingCrawlerJob.perform_async(story_url)

        @rank -= 1
        break if @rank.zero?
      end
      stories
    else
      Rails.logger.error("RoyalRoad API request failed: #{response.code}")
      []
    end
  end

  def crawler_story_url(story_element)
    url = story_element.at_css('.fiction-title a')['href']
    "https://www.royalroad.com#{url}"
  end
end
