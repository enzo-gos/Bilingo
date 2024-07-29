class HomeController < ApplicationController
  def index
    @stories = Story.includes([:author, { cover_image_attachment: :blob }, :primary_genre, :secondary_genre, :rich_text_description]).order(updated_at: :desc).with_published.limit(5)
  end
end
