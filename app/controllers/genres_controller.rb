class GenresController < ApplicationController
  def show
    published_story = Story.includes([:author, :chapters, { cover_image_attachment: :blob }, :primary_genre, :secondary_genre]).with_published

    @stories = published_story.where(primary_genre: { name: params[:id] }).or(published_story.where(secondary_genre: { name: params[:id] }))
    @pagy, @stories = pagy(@stories)
  end
end
