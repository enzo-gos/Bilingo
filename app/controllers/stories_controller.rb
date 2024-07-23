class StoriesController < ApplicationController
  def index
    @stories = StoryQuery.new(name: params[:q]).call
    p @stories
    # @stories = Story.includes([:author, :chapters, { cover_image_attachment: :blob }, :primary_genre, :secondary_genre]).order(updated_at: :desc).with_published
    @pagy, @stories = pagy(@stories)
  end

  def show
    @story = Story.includes([:chapters]).find(params[:id])
    @chapters = @story.chapters.where(published: true)
    authorize @story
  end
end
