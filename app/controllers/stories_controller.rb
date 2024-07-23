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

  def follow
    story = Story.find(params[:id])
    story.toggle_bookmark!(current_user)
    redirect_back fallback_location: root_path
  end
end
