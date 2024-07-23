class ProfilesController < ApplicationController
  before_action :set_author, only: [:show]
  before_action :set_stories, only: [:index, :show]
  before_action :set_author_info, only: [:index, :show]

  def index; end

  def show; end

  private

  def set_author
    @author = User.find(params[:id])
  end

  def set_stories
    @stories = (@author || current_user).stories.includes(:primary_genre, :secondary_genre, :author, { cover_image_attachment: :blob })
  end

  def set_author_info
    @published = @stories.where(id: Chapter.where(published: true).select(:story_id)).size
    @draft = @stories.size - @published
    @report = @stories.where(banned: true).size
  end
end
