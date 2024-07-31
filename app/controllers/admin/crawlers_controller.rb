module Admin
  class CrawlersController < BaseController
    require 'sidekiq/api'

    def show
      story_list = Story.includes([:author, { cover_image_attachment: :blob }]).all.order(:id)
      @pagy, @stories = pagy(story_list)
      @busy_jobs = []

      Sidekiq::Workers.new.each do |_process_id, _thread_id, work|
        payload = JSON.parse(work.instance_variable_get(:@hsh)['payload'])

        next if payload['class'] != 'OngoingCrawlerJob'

        tasks = Sidekiq::Status.get_all(payload['jid'])['story_hash']

        @busy_jobs << JSON.parse(tasks, symbolize_names: true) if tasks.present?
      end
    end

    def fetch_ongoing
      if params[:commit] == 'Preview'
        @stories = CrawlerService::NewStoryFetcher.new(params[:crawl_url], params[:rank]).call
      elsif params[:commit] == 'Crawl'
        @stories = CrawlerService::NewStoryCrawler.new(params[:crawl_url], params[:rank]).call

        sidekiq = Sidekiq::ScheduledSet.new
        job = sidekiq.find { |schedule| schedule.klass == 'ScheduleCrawlStoryJob' && schedule.args[0] == params[:crawl_url] }
        job&.delete

        if params[:schedule] == 'every_week'
          ScheduleCrawlStoryJob.perform_at(1.week.from_now, params[:crawl_url], params[:rank])
        else
          ScheduleCrawlStoryJob.perform_at(1.month.from_now, params[:crawl_url], params[:rank])
        end
        redirect_to admin_crawlers_path, notice: 'Crawl was in progress', turbo_frame: 'top'
      end
    end
  end
end
