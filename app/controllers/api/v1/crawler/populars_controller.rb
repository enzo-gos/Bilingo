class Api::V1::Crawler::PopularsController < ApplicationController
  def new
    stories = CrawlerService::NewStoryFetcher.new.call

    respond_to do |format|
      format.json { render json: stories }
    end
  end
end
