class StoriesController < ApplicationController
  def index
    @stories = StoryQuery.new(name: params[:q]).call
    @pagy, @stories = pagy(@stories)
  end

  def show
    @story = Story.includes([:chapters]).find(params[:id])
    authorize @story

    @chapters = @story.chapters.where(published: true)
    @pagy, @chapters = pagy(@chapters)
    @recently_read = @story.most_recent_chapter_for(request.remote_ip)
  end

  def follow
    story = Story.find(params[:id])
    story.toggle_bookmark!(current_user)
    redirect_back fallback_location: root_path
  end
end
