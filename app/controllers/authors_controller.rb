class AuthorsController < ApplicationController
  def show
    @author = AuthorInfor.find(params[:id])
    @stories = @author.stories.includes(:primary_genre, :secondary_genre, :author, { cover_image_attachment: :blob })

    @published = @stories.where(id: Chapter.where(published: true).select(:story_id)).size
    @draft = @stories.size - @published
    @banned = @author.total_followers
  end
end
