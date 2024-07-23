class StoriesController < ApplicationController
  def index
    @stories = StoryQuery.new(name: params[:q]).call
    @pagy, @stories = pagy(@stories)
  end

  def show
    @story = Story.includes([:chapters]).find(params[:id])
    @chapters = @story.chapters.where(published: true)
    authorize @story
  end
end
