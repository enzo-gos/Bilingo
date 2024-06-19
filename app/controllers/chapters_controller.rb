class ChaptersController < ApplicationController
  def show
    @story = Chapter.find(params[:story_id])
    @chapter = Chapter.find(params[:id])
    @prev_chapter = @chapter.higher_item ? story_chapter_path(story_id: @story.id, id: @chapter.higher_item.id) : nil
    @next_chapter = @chapter.lower_item ? story_chapter_path(story_id: @story.id, id: @chapter.lower_item.id) : nil
  end
end
