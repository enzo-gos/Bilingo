class ChaptersController < ApplicationController
  def show
    params[:translate_code] ||= params[:locale]

    @story = Story.find(params[:story_id])
    @chapter = Chapter.find(params[:id])

    @prev_chapter = @chapter.higher_item ? story_chapter_path(story_id: @story.id, id: @chapter.higher_item.id) : nil
    @next_chapter = @chapter.lower_item ? story_chapter_path(story_id: @story.id, id: @chapter.lower_item.id) : nil

    @translation = ChapterService::Translator.call(chapter: @chapter, source_language: @story.language_code, target_language: params[:translate_code])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('translate-dropdown', partial: 'translate_dropdown', locals: { current_translate: params[:translate_code] }),
          turbo_stream.update('story-content', partial: 'story_content', locals: { original: @translation[:original], translated: @translation[:translated], show_translate: @translation[:show_translate] })
        ]
      end
      format.html
    end
  end
end
