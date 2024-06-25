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
          turbo_stream.update('story-content', partial: 'story_content', locals: { original: @translation[:original], translated: @translation[:translated], rephrases: @rephrasers, show_translate: @translation[:show_translate] })
        ]
      end
      format.html
    end
  end

  def rephrase
    index = params[:index].to_i

    @story = Story.find(params[:story_id])
    @chapter = Chapter.find(params[:id])

    @translation = ChapterService::Translator.call(chapter: @chapter, source_language: @story.language_code, target_language: params[:translate_code])

    original = @translation[:original][:content][index]
    translated = @translation[:translated][:content][index]

    try = 0
    begin
      try += 1
      rephrased = ChapterService::Rephraser.call(chapter: @chapter, dest_language: params[:translate_code], original: original, translated: translated)
    rescue Faraday::TooManyRequestsError
      retry if try < 5
      error = true
    end

    respond_to do |format|
      format.turbo_stream do
        if error
          render turbo_stream: [
            turbo_stream.update("translate_index_#{index}", translated),
            turbo_stream.remove("rephrase_index_#{index}")
          ]
        else
          render turbo_stream: [
            turbo_stream.update("translate_index_#{index}", rephrased),
            turbo_stream.update("translate_info_index_#{index}", 'Rephrased by Gemini'),
            turbo_stream.remove("rephrase_index_#{index}")
          ]
        end
      end
    end
  end
end
