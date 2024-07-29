class TopicsController < ApplicationController
  def show
    @stories = Story.includes([:author, :chapters, { cover_image_attachment: :blob }, :primary_genre, :secondary_genre, :rich_text_description]).with_published.tagged_with(params[:id])
    @pagy, @stories = pagy(@stories)
  end
end
