class Writer::ChaptersController < ApplicationController
  before_action :prepare_story
  before_action :prepare_chapter, except: [:create]

  layout 'writer/chapter'

  def index
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('writer-content', partial: 'writer/stories/chapters')
        ]
      end
    end
  end

  def edit
    @toolbar_title = @story.name
  end

  def create
    authorize @story, policy_class: Writer::StoryPolicy
    chapter = @story.chapters.create
    redirect_to edit_writer_story_chapter_path(story_id: @story.id, id: chapter.id)
  end

  def order
    @chapter.insert_at(params[:position].to_i)
    head :ok
  end

  def publish
    @chapter.published = true
    @chapter.save
    redirect_back(fallback_location: root_path)
  end

  def unpublish
    @chapter.published = false
    @chapter.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @chapter.destroy
    if params[:replace]
      replace_chapter_id = @chapter.lower_item&.id || @chapter.higher_item&.id
      return redirect_to action: :edit, story_id: @chapter.story_id, id: replace_chapter_id if replace_chapter_id

      return redirect_to edit_writer_story_path(@story)
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    @chapter.update(chapter_params)
    respond_to do |format|
      format.json { render json: @chapter }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def chapter_params
    params.require(:chapter).permit(:title, :content, :heading_image)
  end

  def prepare_story
    @story = Story.find(params[:story_id])
  end

  def prepare_chapter
    @chapter = Chapter.find(params[:id])
    authorize @chapter, policy_class: Writer::ChapterPolicy
  end
end
