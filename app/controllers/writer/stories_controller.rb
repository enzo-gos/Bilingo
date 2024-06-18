class Writer::StoriesController < ApplicationController
  include TaggableHelper

  before_action :auth_user
  before_action :prepare_story, except: [:new, :create, :index, :all]
  before_action :set_updatable, only: [:edit, :update]
  before_action :set_new_title, only: [:edit, :update]
  before_action :set_edit_title, only: [:new, :create]

  layout 'writer/editor', except: [:index, :order, :destroy]

  def index
    @my_stories = current_user.stories.includes(:chapters).with_published
  end

  def all
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('workspace-main', partial: 'main', locals: { my_stories: current_user.stories.includes(:chapters) })
        ]
      end
    end
  end

  def new
    @story = Story.new
  end

  def create
    result = StoryService::Creator.call(params: story_params, author: current_user)
    payload = result.payload
    @story = payload[:story]

    if result.success?
      redirect_to edit_writer_story_chapter_path(story_id: @story.id, id: payload[:chapter].id)
    else
      flash.now[:alert] = result.errors
      render :new, status: :unprocessable_entity
    end
  end

  def order
    @story.insert_at(params[:position].to_i)
    head :ok
  end

  def edit; end

  def update
    result = StoryService::Updater.call(params: story_params, story: @story)

    if result.success?
      redirect_to edit_writer_story_path, notice: t('writer_stories.update.success')
    else
      flash.now[:alert] = result.errors
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @story.destroy
      redirect_to writer_stories_path, notice: t('writer_stories.destroy.success')
    else
      redirect_to writer_stories_path, alert: t('writer_stories.destroy.failure')
    end
  end

  private

  def story_params
    params.require(:story).permit(:name, :description, :cover_image, :primary_genre_id, :secondary_genre_id, :tag_list, :language_code)
  end

  def prepare_story
    @story = Story.find(params[:id])
    authorize @story, policy_class: Writer::StoryPolicy
  end

  def set_updatable
    @updatable = true
  end

  def set_new_title
    @toolbar_title = t('writer_toolbar.title')
  end

  def set_edit_title
    @toolbar_title = t('writer_toolbar.editable_title')
  end

  def auth_user
    unless user_signed_in?
      flash[:info] = t('auth.not_signed_in')
      redirect_to root_path
    end
  end
end
