class ScheduleCrawlStoryJob
  include Sidekiq::Job

  def perform(crawl_url, rank)
    CrawlerService::NewStoryCrawler.new(crawl_url, rank).call
  end
end
