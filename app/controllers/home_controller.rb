class HomeController < ApplicationController
  def index
    @stories = Story.includes([:author, :chapters, { cover_image_attachment: :blob }, :primary_genre, :secondary_genre]).with_published.limit(5)
  end
end
