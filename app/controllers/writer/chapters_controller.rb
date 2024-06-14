class Writer::ChaptersController < ApplicationController
  before_action :prepare_story

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

  private

  def prepare_story
    @story = Story.find(params[:story_id])
  end
end
