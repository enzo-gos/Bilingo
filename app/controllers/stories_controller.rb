class StoriesController < ApplicationController
  def index
    @stories = Story.includes([:author, :chapters, { cover_image_attachment: :blob }, :primary_genre, :secondary_genre]).with_published
    @pagy, @stories = pagy(@stories)
  end

  def show
    @story = Story.includes([:chapters]).find(params[:id])
  end
end
