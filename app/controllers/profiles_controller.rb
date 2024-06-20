class ProfilesController < ApplicationController
  def index
    @stories = current_user.stories.includes([:primary_genre, :secondary_genre, :author, { cover_image_attachment: :blob }])
    @published = Story.where(id: Chapter.where(published: true).select(:story_id)).size
    @draft = @stories.size - @published
  end
end
